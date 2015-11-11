using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Math as Math;

// Calculate moving direction.
//
// @param pos[in] old position
// @param newPos[in] new position
// @return moving direction symbol
function getDirection(pos, newPos) {
	var dir = null;

    if (newPos[:y] < pos[:y]) {
    	if (newPos[:y] == 0) {
    		dir = :down;
    	} else {
    		dir = :up;
    	}
    } else if (newPos[:y] > pos[:y]) {
    	if (newPos[:y] == SCREEN_UNIT) {
    		dir = :up;
    	} else {
    		dir = :down;
    	}
    } else if (newPos[:x] < pos[:x]) {
    	if (newPos[:x] == 0) {
    		dir = :right;
    	} else {
    		dir = :left;
    	}
    } else if (newPos[:x] > pos[:x]) {
    	if (newPos[:x] == SCREEN_UNIT) {
    		dir = :left;
    	} else {
    		dir = :right;
    	}
    } else {
    	dir = [:up, :right, :down, :left][Math.rand() % 4];
    }

    return dir;
}

// Calculate the next position along specified direction.
//
// @param pos[in] current position
// @param dir[in] direction for going
// @return next position
function getNextPosition(pos, dir) {
	var nextPos = {};
	if (dir == :up) {
		nextPos[:x] = pos[:x];
		nextPos[:y] = (pos[:y] - 1 + SCREEN_UNIT) % SCREEN_UNIT;
	} else if (dir == :down) {
		nextPos[:x] = pos[:x];
		nextPos[:y] = (pos[:y] + 1 + SCREEN_UNIT) % SCREEN_UNIT;
	} else if (dir == :left) {
		nextPos[:x] = (pos[:x] - 1 + SCREEN_UNIT) % SCREEN_UNIT;
		nextPos[:y] = pos[:y];
	} else if (dir == :right) {
		nextPos[:x] = (pos[:x] + 1 + SCREEN_UNIT) % SCREEN_UNIT;
		nextPos[:y] = pos[:y];
	} else {
		nextPos[:x] = pos[:x];
		nextPos[:y] = pos[:y];
	}

	return nextPos;
}

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
    // @return
    function moveToNextPos(dc) {
        var nextPos = _findNextPos();
        dir = getDirection(pos, nextPos);
        _erase(dc);
        pos = nextPos;
        _draw(dc);
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
    		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    		dc.fillPolygon([
    			[X + 4, Y],
    			[X + 7, Y + 8],
    			[X + 10, Y],
    			[X + 4, Y]
    		]);
    	} else if (dir == :down) {
    		dc.setColor(color, Gfx.COLOR_BLACK);
    		dc.fillRoundedRectangle(X + 1, Y + 1, 12, 13, 4);
    		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    		dc.fillPolygon([
    			[X + 4, Y + 14],
    			[X + 7, Y + 6],
    			[X + 10, Y + 14],
    			[X + 4, Y + 14]
    		]);
    	} else if (dir == :left) {
    		dc.setColor(color, Gfx.COLOR_BLACK);
    		dc.fillRoundedRectangle(X, Y + 1, 13, 12, 4);
    		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    		dc.fillPolygon([
    			[X, Y + 4],
    			[X + 8, Y + 7],
    			[X, Y + 10],
    			[X, Y + 4]
    		]);
    	} else if (dir == :right) {
    		dc.setColor(color, Gfx.COLOR_BLACK);
    		dc.fillRoundedRectangle(X + 1, Y + 1, 13, 12, 4);
    		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    		dc.fillPolygon([
    			[X + 14, Y + 4],
    			[X + 5, Y + 7],
    			[X + 14, Y + 10],
    			[X + 14, Y + 4]
    		]);
    	} else {
    	}
    }

    // Find next position according to current playground situation.
    //
    // @return next position
    hidden function _findNextPos() {
    	// It is reasonable that pacman walks along his previous direction.
		// So if possible, we just let him walk in that way.
		if (_isDirectionValid(dir)) {
			return getNextPosition(pos, dir);
		}

		// If previous direction is invalid, pacman will find and choose one
		// other direction to move.
		// TODO: Currently we just let pacman hang around, the only strategy
		// of finding next position is do not hit the barrier. In the future,
		// I will add more complex strategies for routing.
        var dirs = new [3];
        var cnt = 0;

        if (:up != dir && _isDirectionValid(:up)) {
        	dirs[cnt] = :up;
        	cnt++;
        }
        if (:right != dir && _isDirectionValid(:right)) {
        	dirs[cnt] = :right;
        	cnt++;
        }
        if (:down != dir && _isDirectionValid(:down)) {
        	dirs[cnt] = :down;
        	cnt++;
        }
        if (:left != dir && _isDirectionValid(:left)) {
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
	// @param dir[in] direction for going.
	// @return true or false.
    hidden function _isDirectionValid(dir) {
    	// TODO: Currently the only strategy of deciding the validation
		// of a direction is to check whether the next position along that
		// direction is empty. In the future, I will add some more complex
		// strategy.
    	var nextPos = getNextPosition(pos, dir);
    	return plg.get(nextPos) == :nil;
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
    // @return
    function moveToNextPos(dc) {
        var nextPos = _findNextPos();
        dir = getDirection(pos, nextPos);
        _erase(dc);
        pos = nextPos;
        _draw(dc);
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

    	dc.setColor(color, Gfx.COLOR_BLACK);
    	// Draw body
    	dc.setColor(color, Gfx.COLOR_BLACK);
    	dc.drawLine(X, Y + 6, X, Y + 13);
    	dc.drawLine(X + 1, Y + 3, X + 1, Y + 14);
    	dc.drawLine(X + 2, Y + 2, X + 2, Y + 14);
    	dc.drawLine(X + 3, Y + 1, X + 3, Y + 13);
    	dc.drawLine(X + 4, Y + 1, X + 4, Y + 12);
    	dc.drawLine(X + 5, Y, X + 5, Y + 13);
    	dc.drawLine(X + 6, Y, X + 6, Y + 14);
    	dc.drawLine(X + 7, Y, X + 7, Y + 14);
    	dc.drawLine(X + 8, Y, X + 8, Y + 13);
    	dc.drawLine(X + 9, Y + 1, X + 9, Y + 12);
    	dc.drawLine(X + 10, Y + 1, X + 10, Y + 13);
    	dc.drawLine(X + 11, Y + 2, X + 11, Y + 14);
    	dc.drawLine(X + 12, Y + 3, X + 12, Y + 14);
    	dc.drawLine(X + 13, Y + 6, X + 13, Y + 13);

    	// Draw eyes
    	if (dir == :up) {
    		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    		dc.fillRectangle(X + 2, Y + 4, 4, 3);
			dc.fillRectangle(X + 3, Y + 3, 2, 5);
			dc.fillRectangle(X + 8, Y + 4, 4, 3);
			dc.fillRectangle(X + 9, Y + 3, 2, 5);
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    		dc.fillRectangle(X + 3, Y + 3, 2, 2);
    		dc.fillRectangle(X + 9, Y + 3, 2, 2);
    	} else if (dir == :down) {
    		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    	   	dc.fillRectangle(X + 2, Y + 4, 4, 3);
			dc.fillRectangle(X + 3, Y + 3, 2, 5);
			dc.fillRectangle(X + 8, Y + 4, 4, 3);
			dc.fillRectangle(X + 9, Y + 3, 2, 5);
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    		dc.fillRectangle(X + 3, Y + 6, 2, 2);
    		dc.fillRectangle(X + 9, Y + 6, 2, 2);
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
		// TODO: Currently we just let pacman hang around, the only strategy
		// of finding next position is do not hit the barrier. In the future,
		// I will add more complex strategies for routing.
        var dirs = new [3];
        var cnt = 0;

        if (:up != dir && _isDirectionValid(:up)) {
        	dirs[cnt] = :up;
        	cnt++;
        }
        if (:right != dir && _isDirectionValid(:right)) {
        	dirs[cnt] = :right;
        	cnt++;
        }
        if (:down != dir && _isDirectionValid(:down)) {
        	dirs[cnt] = :down;
        	cnt++;
        }
        if (:left != dir && _isDirectionValid(:left)) {
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
	// @param dir[in] direction for going.
	// @return true or false.
    hidden function _isDirectionValid() {
    	// TODO: Currently the only strategy of deciding the validation
		// of a direction is to check whether the next position along that
		// direction is empty. In the future, I will add some more complex
		// strategy.
    	var nextPos = getNextPosition(pos, dir);
    	return plg.get(nextPos) == :nil;
    }
}