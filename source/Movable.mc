using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Math as Math;


// Movable indicates anything on the playground that is movable:)
// Every movable object knows the playground map and its position.
class Movable {
    // Position on the playground.
    // For example:
    // {:x => x, :y => y}
    var pos;

    // Moving direction.
    // Could be one of those: symbols:
    // [:up, :right, :down, :left]
    var dir;

    // Playground object.
    // @see Playground
    var plg;

    // Initialize function.
    // The built-in initialize function is limited, so we decide to
    // initialize the object explicitly.
    //
    // @param plg[in] The playground object
    // @param pos[in] The initial position
    // @param dir[in] The initial direction
    // @return
    function init(plg, pos, dir) {
        self.plg = plg;
        self.pos = pos;
        self.dir = dir;
    }

    // Uninitialize function.
    // Monkey-C uses reference-counting mechanism for garbage collection,
    // so it has the problem of recursive reference. To avoid memory leak,
    // we should also call this uninitialize function explicitly to release
    // references.
    //
    // @return
    function uninit() {
        pos = null;
        dir = null;
        plg = null;
    }
}


// Pacman
class Pacman extends Movable {
	var color;
    // Initialize function.
    // @see Movable
    //
    // @param plg[in] The playground object
    // @param pos[in] The initial position
    // @param dir[in] The initial direction
    // @return
    function init(plg, pos, dir) {
        Movable.init(plg, pos, dir);
        color = 0xFFFF00;
        plg.set(pos, :pacman);
    }

    // Uninitialize function.
    // @see Movable
    //
    // @return
    function uninit() {
        Movable.uninit();
    }

    // Moves to next position and draws relative part of screen.
    //
    // @param dc[in] device context which is used for drawing
    // @return true if game is continuing or false if it is over
    function moveToNextPos(dc) {
        var nextPos = _findNextPos();
        dir = getDirection(pos, nextPos);
        _erase(dc);
        pos = nextPos;
        _draw(dc);
        return true;
    }

    // Erase images of current position.
    //
    // @param dc[in] device context which is used for drawing
    // @return
    hidden function _erase(dc) {
    	plg.set(pos, :nil);
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.fillRectangle(pos[:x] * UNIT_SIZE, pos[:y] * UNIT_SIZE, UNIT_SIZE, UNIT_SIZE);
    }

    // Draw pacman at current position.
    //
    // @pram dc[in] device context which is used for drawing
    // @return
    hidden function _draw(dc) {
    	// Mark playground
    	plg.set(pos, :pacman);

		// Garmin ConnectIQ does some differential caculation when displays
		// bitmap, which will cause the color looks weird. As a completist,
		// I have no choice but draw the image handfully ;)
		var X = scale(pos[:x]);
		var Y = scale(pos[:y]);

    	// Every direction has its own picture.
    	if (dir == :up) {
    		dc.setColor(color, Gfx.COLOR_BLACK);
    		dc.fillRoundedRectangle(X + 1, Y, 12, 13, 4);
    		fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
    			[4, 0],
    			[7, 8],
    			[10, 0],
    			[4, 0]
    		]);
    	} else if (dir == :down) {
    		dc.setColor(color, Gfx.COLOR_BLACK);
    		dc.fillRoundedRectangle(X + 1, Y + 1, 12, 13, 4);
    		fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
    			[4, 14],
    			[7, 6],
    			[10, 14],
    			[4, 14]
    		]);
    	} else if (dir == :left) {
    		dc.setColor(color, Gfx.COLOR_BLACK);
    		dc.fillRoundedRectangle(X, Y + 1, 13, 12, 4);
    		fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
    			[0, 4],
    			[8, 7],
    			[0, 10],
    			[0, 4]
    		]);
    	} else if (dir == :right) {
    		dc.setColor(color, Gfx.COLOR_BLACK);
    		dc.fillRoundedRectangle(X + 1, Y + 1, 13, 12, 4);
    		fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
    			[14, 4],
    			[5, 7],
    			[14, 10],
    			[14, 4]
    		]);
    	} else {
    	}
    }

    // Find next position according to current playground situation.
    //
    // @return next position
    hidden function _findNextPos() {
    	// It is reasonable that pacman walks along his previous direction.
		// So if possible, we just let him walk in that way(70% possibility).
		if (_isDirectionValid(dir) && (Math.rand() % 10 > 2)) {
			return getNextPosition(pos, dir);
		}

		// If previous direction is invalid, pacman will find and choose one
		// other direction to move.
        var dirs = new [4];
        var cnt = 0;

        if (_isDirectionValid(:up)) {
        	dirs[cnt] = :up;
        	cnt++;
        }
        if (_isDirectionValid(:right)) {
        	dirs[cnt] = :right;
        	cnt++;
        }
        if (_isDirectionValid(:down)) {
        	dirs[cnt] = :down;
        	cnt++;
        }
        if (_isDirectionValid(:left)) {
        	dirs[cnt] = :left;
        	cnt++;
        }

        if (cnt > 0) {
        	// If more than one directions are valid, select any of them randomly.
        	return getNextPosition(pos, dirs[Math.rand() % cnt]); // TODO: srand
        } else {
        	// Otherwise, just stands still.
        	return getNextPosition(pos, null);
        }
    }

	// Decide whether the specified direction is valid for going.
	//
	// @param dir[in] direction for going
	// @return true or false
    hidden function _isDirectionValid(dir) {
    	// If next position along the current direction is not empty, return false.
    	var nextPos = getNextPosition(pos, dir);
    	if (plg.get(nextPos) != :nil) {
    		return false;
    	}

    	// Look another 5 more positions in current direciton.
		// If there is a ghost, return false, otherwise return true.
    	for (var i = 1; i <= 5; i++) {
    		nextPos = getNextPosition(nextPos, dir);
    		if (plg.get(nextPos) == :ghost) {
    			return false;
    		} else if (plg.get(nextPos) != :nil) {
    			break;
    		}
    	}
    	return true;
    }
}


// Ghost
class Ghost extends Movable {
	// The color of ghost.
	var color;

    // Initialize function.
    // @see Movable
    //
    // @param plg[in] The playground object
    // @param pos[in] The initial position
    // @param dir[in] The initial direction
    // @poram color[in] The color of ghost.
    // @return
    function init(plg, pos, dir, color) {
        Movable.init(plg, pos, dir);
        self.color = color;

        plg.set(pos, :ghost);
    }

    // Uninitialize function.
    // @see Movable
    //
    // @return
    function uninit() {
        Movable.uninit();
    }

    // Moves to next position and draws relative part of screen.
    //
    // @param dc[in] device context which is used for drawing
    // @return true if game is continuing or false if it is over
    function moveToNextPos(dc) {
        var nextPos = _findNextPos();
        // Gameover!
        if (plg.get(nextPos) == :pacman) {
        	return false;
        }
        dir = getDirection(pos, nextPos);
        _erase(dc);
        pos = nextPos;
        _draw(dc);
        return true;
    }

    // Erase images of current position.
    //
    // @param dc[in] device context which is used for drawing
    // @return
    hidden function _erase(dc) {
    	plg.set(pos, :nil);
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.fillRectangle(pos[:x] * UNIT_SIZE, pos[:y] * UNIT_SIZE, UNIT_SIZE, UNIT_SIZE);
    }

    // Draw images of current position.
    //
    // @pram dc[in] device context which is used for drawing
    // @return
    hidden function _draw(dc) {
    	// Mark playground
    	plg.set(pos, :ghost);

		// Garmin ConnectIQ does some differential caculation when displays
		// bitmap, which will cause the color looks weird. As a completist,
		// I have no choice but draw the image handfully ;)
		var X = scale(pos[:x]);
		var Y = scale(pos[:y]);

    	// Draw body
    	drawLine(dc, color, X, Y, 0, 6, 0, 13);
    	drawLine(dc, color, X, Y, 1, 3, 1, 14);
    	drawLine(dc, color, X, Y, 2, 2, 2, 14);
    	drawLine(dc, color, X, Y, 3, 1, 3, 13);
    	drawLine(dc, color, X, Y, 4, 1, 4, 12);
    	drawLine(dc, color, X, Y, 5, 0, 5, 13);
    	drawLine(dc, color, X, Y, 6, 0, 6, 14);
    	drawLine(dc, color, X, Y, 7, 0, 7, 14);
    	drawLine(dc, color, X, Y, 8, 0, 8, 13);
    	drawLine(dc, color, X, Y, 9, 1, 9, 12);
    	drawLine(dc, color, X, Y, 10, 1, 10, 13);
    	drawLine(dc, color, X, Y, 11, 2, 11, 14);
    	drawLine(dc, color, X, Y, 12, 3, 12, 14);
    	drawLine(dc, color, X, Y, 13, 6, 13, 13);

    	// Draw eyes
    	if (dir == :up || dir == :down) {
    		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    		dc.fillRectangle(X + 2, Y + 4, 4, 3);
			dc.fillRectangle(X + 3, Y + 3, 2, 5);
			dc.fillRectangle(X + 8, Y + 4, 4, 3);
			dc.fillRectangle(X + 9, Y + 3, 2, 5);
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
			if (dir == :up) {
    			dc.fillRectangle(X + 3, Y + 3, 2, 2);
    			dc.fillRectangle(X + 9, Y + 3, 2, 2);
    		} else {
    			dc.fillRectangle(X + 3, Y + 6, 2, 2);
    			dc.fillRectangle(X + 9, Y + 6, 2, 2);
    		}
    	} else if (dir == :left) {
    		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    		dc.fillRectangle(X + 1, Y + 4, 4, 3);
			dc.fillRectangle(X + 2, Y + 3, 2, 5);
			dc.fillRectangle(X + 7, Y + 4, 4, 3);
			dc.fillRectangle(X + 8, Y + 3, 2, 5);
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    		dc.fillRectangle(X + 1, Y + 5, 2, 2);
    		dc.fillRectangle(X + 7, Y + 5, 2, 2);
    	} else if (dir == :right) {
    		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    		dc.fillRectangle(X + 3, Y + 4, 4, 3);
			dc.fillRectangle(X + 4, Y + 3, 2, 5);
			dc.fillRectangle(X + 9, Y + 4, 4, 3);
			dc.fillRectangle(X + 10, Y + 3, 2, 5);
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    		dc.fillRectangle(X + 5, Y + 5, 2, 2);
    		dc.fillRectangle(X + 11, Y + 5, 2, 2);
    	} else {
    	}
    }

    // Find next position according to current playground situation.
    //
    // @return next position
    hidden function _findNextPos() {
        // It is reasonable that ghost walks along his previous direction.
		// So if possible, we just let him walk in that way.
		if (_isDirectionValid(dir)) {
			return getNextPosition(pos, dir);
		}

		// If previous direction is invalid, pacman will find and choose one
		// other direction to move.
		var validDirs = [:up, :right, :down, :left];
        var dirs = new [4];
        var cnt = 0;

		for (var i = 0; i < 4; i++) {
			if (_isDirectionValid(validDirs[i])) {
				dirs[cnt] = validDirs[i];
				cnt++;
			}
			if (_foundPacman(validDirs[i])) {
				return getNextPosition(pos, validDirs[i]);
			}
		}

        if (cnt > 0) {
        	// If more than one directions are valid, select any of them randomly.
        	return getNextPosition(pos, dirs[Math.rand() % cnt]); // TODO: srand
        } else {
        	// Otherwise, just stands still.
        	return getNextPosition(pos, null);
        }
    }

	// Decide whether the specified direction is valid for going.
	//
	// @param dir[in] direction for going
	// @return true or false
    hidden function _isDirectionValid() {
    	// TODO: Currently the only strategy of deciding the validation
		// of a direction is to check whether the next position along that
		// direction is empty. In the future, I will add some more complex
		// strategy.
    	var nextPos = getNextPosition(pos, dir);
    	return plg.get(nextPos) == :nil;
    }

    // Determine whether the ghost can see the pacman along the specified direction.
    //
    // @param towards[in] the direction that ghots is looking
    // @return true or false
    hidden function _foundPacman(towards) {
    	var next = getNextPosition(pos, towards);
    	while (plg.get(next) == :nil) {
    		next = getNextPosition(next, towards);
    	}
    	return plg.get(next) == :pacman;
    }
}