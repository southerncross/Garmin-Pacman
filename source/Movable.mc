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

function scale(c) {
	return c * UNIT_SIZE;
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
    // Initialize function.
    // @see Movable
    //
    // @param plg[in] The playground object
    // @param pos[in] The initial position
    // @param dir[in] The initial direction
    // @poram bm[in] The bitmap resources.
    // @return
    function init(plg, pos, dir) {
        Movable.init(plg, pos, dir);
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

    // Draw images of current position.
    //
    // @pram dc[in] device context which is used for drawing
    // @return
    hidden function _draw(dc) {
    	plg.set(pos, :pacman);

    	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_BLACK);
    	if (dir == :up) {
    		dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 4, scale(pos[:x]) + 1, scale(pos[:y]) + 9);
    		dc.drawLine(scale(pos[:x]) + 2, scale(pos[:y]) + 2, scale(pos[:x]) + 2, scale(pos[:y]) + 11);
    		dc.drawLine(scale(pos[:x]) + 3, scale(pos[:y]) + 1, scale(pos[:x]) + 3, scale(pos[:y]) + 12);
    		dc.drawLine(scale(pos[:x]) + 4, scale(pos[:y]) + 1, scale(pos[:x]) + 4, scale(pos[:y]) + 12);
    		dc.drawLine(scale(pos[:x]) + 5, scale(pos[:y]) + 3, scale(pos[:x]) + 5, scale(pos[:y]) + 13);
    		dc.drawLine(scale(pos[:x]) + 6, scale(pos[:y]) + 6, scale(pos[:x]) + 6, scale(pos[:y]) + 13);
    		dc.drawLine(scale(pos[:x]) + 7, scale(pos[:y]) + 8, scale(pos[:x]) + 7, scale(pos[:y]) + 13);
    		dc.drawLine(scale(pos[:x]) + 8, scale(pos[:y]) + 6, scale(pos[:x]) + 8, scale(pos[:y]) + 13);
    		dc.drawLine(scale(pos[:x]) + 9, scale(pos[:y]) + 3, scale(pos[:x]) + 9, scale(pos[:y]) + 13);
    		dc.drawLine(scale(pos[:x]) + 10, scale(pos[:y]) + 1, scale(pos[:x]) + 10, scale(pos[:y]) + 12);
    		dc.drawLine(scale(pos[:x]) + 11, scale(pos[:y]) + 1, scale(pos[:x]) + 11, scale(pos[:y]) + 12);
    		dc.drawLine(scale(pos[:x]) + 12, scale(pos[:y]) + 2, scale(pos[:x]) + 12, scale(pos[:y]) + 11);
    		dc.drawLine(scale(pos[:x]) + 13, scale(pos[:y]) + 4, scale(pos[:x]) + 13, scale(pos[:y]) + 9);
    	} else if (dir == :down) {
    		dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 5, scale(pos[:x]) + 1, scale(pos[:y]) + 10);
    		dc.drawLine(scale(pos[:x]) + 2, scale(pos[:y]) + 3, scale(pos[:x]) + 2, scale(pos[:y]) + 12);
    		dc.drawLine(scale(pos[:x]) + 3, scale(pos[:y]) + 2, scale(pos[:x]) + 3, scale(pos[:y]) + 13);
    		dc.drawLine(scale(pos[:x]) + 4, scale(pos[:y]) + 2, scale(pos[:x]) + 4, scale(pos[:y]) + 13);
    		dc.drawLine(scale(pos[:x]) + 5, scale(pos[:y]) + 1, scale(pos[:x]) + 5, scale(pos[:y]) + 11);
    		dc.drawLine(scale(pos[:x]) + 6, scale(pos[:y]) + 1, scale(pos[:x]) + 6, scale(pos[:y]) + 8);
    		dc.drawLine(scale(pos[:x]) + 7, scale(pos[:y]) + 1, scale(pos[:x]) + 7, scale(pos[:y]) + 5);
    		dc.drawLine(scale(pos[:x]) + 8, scale(pos[:y]) + 1, scale(pos[:x]) + 8, scale(pos[:y]) + 8);
    		dc.drawLine(scale(pos[:x]) + 9, scale(pos[:y]) + 1, scale(pos[:x]) + 9, scale(pos[:y]) + 11);
    		dc.drawLine(scale(pos[:x]) + 10, scale(pos[:y]) + 2, scale(pos[:x]) + 10, scale(pos[:y]) + 13);
    		dc.drawLine(scale(pos[:x]) + 11, scale(pos[:y]) + 2, scale(pos[:x]) + 11, scale(pos[:y]) + 13);
    		dc.drawLine(scale(pos[:x]) + 12, scale(pos[:y]) + 3, scale(pos[:x]) + 12, scale(pos[:y]) + 12);
    		dc.drawLine(scale(pos[:x]) + 13, scale(pos[:y]) + 5, scale(pos[:x]) + 13, scale(pos[:y]) + 10);
    	} else if (dir == :left) {
    		dc.drawLine(scale(pos[:x]) + 4, scale(pos[:y]) + 1, scale(pos[:x]) + 9, scale(pos[:y]) + 1);
    		dc.drawLine(scale(pos[:x]) + 2, scale(pos[:y]) + 2, scale(pos[:x]) + 11, scale(pos[:y]) + 2);
    		dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 3, scale(pos[:x]) + 12, scale(pos[:y]) + 3);
    		dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 4, scale(pos[:x]) + 12, scale(pos[:y]) + 4);
    		dc.drawLine(scale(pos[:x]) + 3, scale(pos[:y]) + 5, scale(pos[:x]) + 13, scale(pos[:y]) + 5);
    		dc.drawLine(scale(pos[:x]) + 6, scale(pos[:y]) + 6, scale(pos[:x]) + 13, scale(pos[:y]) + 6);
    		dc.drawLine(scale(pos[:x]) + 9, scale(pos[:y]) + 7, scale(pos[:x]) + 13, scale(pos[:y]) + 7);
			dc.drawLine(scale(pos[:x]) + 6, scale(pos[:y]) + 8, scale(pos[:x]) + 13, scale(pos[:y]) + 8);
			dc.drawLine(scale(pos[:x]) + 3, scale(pos[:y]) + 9, scale(pos[:x]) + 13, scale(pos[:y]) + 9);
			dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 10, scale(pos[:x]) + 12, scale(pos[:y]) + 10);
			dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 11, scale(pos[:x]) + 12, scale(pos[:y]) + 11);
			dc.drawLine(scale(pos[:x]) + 2, scale(pos[:y]) + 12, scale(pos[:x]) + 11, scale(pos[:y]) + 12);
			dc.drawLine(scale(pos[:x]) + 4, scale(pos[:y]) + 13, scale(pos[:x]) + 9, scale(pos[:y]) + 13); 
    	} else if (dir == :right) {
    		dc.drawLine(scale(pos[:x]) + 5, scale(pos[:y]) + 1, scale(pos[:x]) + 10, scale(pos[:y]) + 1);
    		dc.drawLine(scale(pos[:x]) + 3, scale(pos[:y]) + 2, scale(pos[:x]) + 12, scale(pos[:y]) + 2);
    		dc.drawLine(scale(pos[:x]) + 2, scale(pos[:y]) + 3, scale(pos[:x]) + 13, scale(pos[:y]) + 3);
    		dc.drawLine(scale(pos[:x]) + 2, scale(pos[:y]) + 4, scale(pos[:x]) + 13, scale(pos[:y]) + 4);
    		dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 5, scale(pos[:x]) + 11, scale(pos[:y]) + 5);
    		dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 6, scale(pos[:x]) + 8, scale(pos[:y]) + 6);
    		dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 7, scale(pos[:x]) + 5, scale(pos[:y]) + 7); //
			dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 8, scale(pos[:x]) + 8, scale(pos[:y]) + 8);
			dc.drawLine(scale(pos[:x]) + 1, scale(pos[:y]) + 9, scale(pos[:x]) + 11, scale(pos[:y]) + 9);
			dc.drawLine(scale(pos[:x]) + 2, scale(pos[:y]) + 10, scale(pos[:x]) + 13, scale(pos[:y]) + 10);
			dc.drawLine(scale(pos[:x]) + 2, scale(pos[:y]) + 11, scale(pos[:x]) + 13, scale(pos[:y]) + 11);
			dc.drawLine(scale(pos[:x]) + 3, scale(pos[:y]) + 12, scale(pos[:x]) + 12, scale(pos[:y]) + 12);
			dc.drawLine(scale(pos[:x]) + 5, scale(pos[:y]) + 13, scale(pos[:x]) + 10, scale(pos[:y]) + 13); 
    	} else {
    	}
        //dc.drawBitmap(pos[:x] * UNIT_SIZE, pos[:y] * UNIT_SIZE, bm[dir]);
    }

    // Find next position according to current playground situation.
    //
    // @return next position
    hidden function _findNextPos() {
    	// Move along previous direction.
		if (_isDirectionValid(dir)) {
			return getNextPosition(pos, dir);
		}

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
        	dirs[cnt] = :right;
        	cnt++;
        }
        if (:left != dir && _isDirectionValid(:left)) {
        	dirs[cnt] = :left;
        	cnt++;
        }

        if (cnt > 0) {
        	return getNextPosition(pos, dirs[Math.rand() % cnt]); // TODO: srand
        } else {
        	return getNextPosition(pos, null);
        }
    }

    hidden function _isDirectionValid(dir) {
    	var nextPos = getNextPosition(pos, dir);
    	return plg.get(nextPos) == :nil;
    }
}


// Ghost
class Ghost extends Movable {
    // Bitmap resources which is used for draw pacman.
    // It has four pictures for each directions in total.
    //
    // TODO: ConnectIQ will does some differential computation of bitmap color
    // which leads to impure color. We should use vector drawing instead of
    // bitmap.
    var bm;

    // Initialize function.
    // @see Movable
    //
    // @param plg[in] The playground object
    // @param pos[in] The initial position
    // @param dir[in] The initial direction
    // @poram bm[in] The bitmap resources.
    // @return
    function init(plg, pos, dir, bm) {
        Movable.init(plg, pos, dir);
        self.bm = bm;

        plg.set(pos, :ghost);
    }

    // Uninitialize function.
    // @see Movable
    //
    // @return
    function uninit() {
        bm = null;
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
    	plg.set(pos, :ghost);
        dc.drawBitmap(pos[:x] * UNIT_SIZE, pos[:y] * UNIT_SIZE, bm[dir]);
    }

    // Find next position according to current playground situation.
    //
    // @return next position
    hidden function _findNextPos() {
        // Move along previous direction.
		if (_isDirectionValid(dir)) {
			return getNextPosition(pos, dir);
		}

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
        	dirs[cnt] = :right;
        	cnt++;
        }
        if (:left != dir && _isDirectionValid(:left)) {
        	dirs[cnt] = :left;
        	cnt++;
        }

        if (cnt > 0) {
        	return getNextPosition(pos, dirs[Math.rand() % cnt]); // TODO: srand
        } else {
        	return getNextPosition(pos, null);
        }
    }

    hidden function _isDirectionValid() {
    	var nextPos = getNextPosition(pos, dir);
    	return plg.get(nextPos) == :nil;
    }
}