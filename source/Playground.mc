using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

// Playground of pacman game
class Playground {
	// Playground map, 2d array actually.
	var plg;

	var prevHours;

	var prevMinutes;

	// Initialize function.
	// The built-in initialize function is limited, so we decide to
	// initialize the object explicitly.
	//
	// @return
	function init() {
		prevHours = [-1, -1];
		prevMinutes = [-1, -1];

		// Puzzle template. The definition is:
		//   " " indicates empty unit.
		//   "|", "-" or "+" indicates barrier.
		//   "h" indicates hour.
		//   "m" indicates minute.
		var tpl = [
			"| ++ || || ++ |",
			"|    ++ ++    |",
			"| ++       ++ |",
			"|   hhh hhh   |",
			"+-+ hhh hhh +-+",
			"  | hhh hhh |  ",
			"--+ hhh hhh +--",
			"               ",
			"--+ + mm mm +--",
			"  |   mm mm |  ",
			"+-+ + mm mm +-+",
			"|             |",
			"| + +++ +++ + |",
			"|    || ||    |",
			"| ++ || || ++ |"
		];

		// Since MonkeyC does not allow access string at specified index.
		// So we have to convert the template into 2d array.
		plg = new [SCREEN_UNIT];
		for (var i = 0; i < SCREEN_UNIT; i++) {
			plg[i] = new [SCREEN_UNIT];
			for (var j = 0; j < SCREEN_UNIT; j++) {
				var c = tpl[j].substring(i, i + 1);
				if (c.equals(" ")) {
					plg[i][j] = :nil;
				} else if (c.equals("h")) {
					plg[i][j] = :hour;
				} else if (c.equals("m")) {
					plg[i][j] = :minute;
				} else {
					plg[i][j] = :barrier;
				}
			}
		}
	}

	// Uninitialize function.
	// Monkey-C uses reference-counting mechanism for garbage collection,
	// so it has the problem of recursive reference. To avoid memory leak,
	// we should also call this uninitialize function explicitly to release
	// references.
	//
	// @return
	function uninit() {
		itms = null;
		plg = null;
	}

	function loadBm(hBm, mBm) {
		self.hBm = hBm;
		self.mBm = mBm;
	}

 	// Update playground.
 	// There exist something that need to be updated as time goes by.
 	// For example, time should be checked and updated.
 	//
 	// @param dc[in] device context which is used for drawing
	// @param lazy[in] in lazy mode, time will not be drew if it equals to previous one
 	// @return
 	function update(dc, lazy) {
 		_drawBackground(dc, lazy);
		_drawTime(dc, lazy);
 	}

	// Return the symbol at specified position.
	//
	// @param pos[in] the position to look at.
	// @return symbol.
 	function get(pos) {
 		return plg[pos[:x]][pos[:y]];
 	}

	// Set a position with specified symbol.
	//
	// @param pos[in] the position to be set
	// @param symbol[in] the symbol to be set.
	// @return
 	function set(pos, symbol) {
 		plg[pos[:x]][pos[:y]] = symbol;
 	}

	// Draw the background of playground.
	// Since background is stable, so we should not evoke this method
	// every time.
	//
	// @param dc[in] the device context for drawing
	// @param lazy[in] in lazy mode, background will not be drew
	// @return
 	hidden function _drawBackground(dc, lazy) {
 		if (lazy) {
 			return;
 		}

 		dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);

 		for (var i = 0; i < SCREEN_UNIT; i++) {
 			for (var j = 0; j < SCREEN_UNIT; j++) {
 				_drawUnit(dc, {:x => i, :y => j});
 			}
 		}
 	}

 	hidden function _drawTime(dc, lazy) {
 		// Update & draw time.
		var clockTime = Sys.getClockTime();
        var h1 = clockTime.hour / 10;
        var h2 = clockTime.hour % 10;
        var m1 = clockTime.min / 10;
        var m2 = clockTime.min % 10;

        if (!lazy || h1 != prevHours[0]) {
        	_drawHour(dc, h1, {:x => 4, :y => 3});
        	prevHours[0] = h1;
        }
        if (!lazy || h2 != prevHours[1]) {
        	_drawHour(dc, h2, {:x => 8, :y => 3});
        	prevHours[1] = h2;
        }
        if (!lazy || m1 != prevMinutes[0]) {
        	_drawMinute(dc, m1, {:x => 6, :y => 8});
        	prevMinutes[0] = m1;
        }
        if (!lazy || m2 != prevMinutes[1]) {
        	_drawMinute(dc, m2, {:x => 9, :y => 8});
        	prevMinutes[1] = m2;
        }
 	}

	// Draw a unit of screen.
	// Actually here we only draw barriers.
	//
	// @param dc[in] the device contex for drawing
	// @param pos[in] position of the unit
	// @return
 	hidden function _drawUnit(dc, pos) {
 		var x = pos[:x];
 		var y = pos[:y];
 		if (plg[x][y] == :barrier) {
 			var X = x * UNIT_SIZE;
 			var Y = y * UNIT_SIZE;
 			// Whether the top border of this unit should be drew
 			var top = (y == 0 || plg[x][y - 1] != :barrier);
 			// Whether the bottom border of this unit should be drew
 			var bottom = (y == SCREEN_UNIT - 1 || plg[x][y + 1] != :barrier);
 			// Whether the left border of this unit should be drew
 			var left = (x == 0 || plg[x - 1][y] != :barrier);
 			// Whether the right border of this unit should be drew
 			var right = (x == SCREEN_UNIT - 1 || plg[x + 1][y] != :barrier);

			// No other choice, T-T
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillRectangle(scale(x), scale(y), UNIT_SIZE, UNIT_SIZE);
			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			if (top) {
 				if (left) {
 					dc.drawLine(X + 5, Y + 2, X + 7, Y + 2);
 					dc.drawLine(X + 4, Y + 3, X + 3, Y + 4);
 					dc.drawLine(X + 2, Y + 5, X + 2, Y + 7);
 				} else {
 					dc.drawLine(X, Y + 2, X + 7, Y + 2);
 				}
 				if (right) {
 					dc.drawLine(X + 7, Y + 2, X + 9, Y + 2);
 					dc.drawLine(X + 10, Y + 3, X + 11, Y + 4);
 					dc.drawLine(X + 12, Y + 5, X + 12, Y + 7);
 				} else {
 					dc.drawLine(X + 7, Y + 2, X + 14, Y + 2);
 				}
 			} else {
 				if (left) {
 					dc.drawLine(X + 2, Y, X + 2, Y + 7);
 				} else {
 					dc.drawLine(X + 2, Y, X + 2, Y + 1);
 					dc.drawLine(X, Y + 2, X + 1, Y + 2);
 				}
 				if (right) {
 					dc.drawLine(X + 12, Y, X + 12, Y + 7);
 				} else {
 					dc.drawLine(X + 12, Y, X + 12, Y + 1);
 					dc.drawLine(X + 13, Y + 2, X + 13, Y + 2);
 				}
 			}

 			if (bottom) {
 				if (left) {
 					dc.drawLine(X + 2, Y + 7, X + 2, Y + 9);
 					dc.drawLine(X + 3, Y + 10, X + 4, Y + 11);
 					dc.drawLine(X + 5, Y + 12, X + 7, Y + 12);
 				} else {
 					dc.drawLine(X, Y + 12, X + 7, Y + 12);
 				}

 				if (right) {
 					dc.drawLine(X + 12, Y + 7, X + 12, Y + 9);
 					dc.drawLine(X + 11, Y + 10, X + 10, Y + 11);
 					dc.drawLine(X + 7, Y + 12, X + 9, Y + 12);
 				} else {
 					dc.drawLine(X + 7, Y + 12, X + 14, Y + 12);
 				}
 			} else {
 				if (left) {
 					dc.drawLine(X + 2, Y + 7, X + 2, Y + 14);
 				} else {
 					dc.drawLine(X + 2, Y + 12, X + 2, Y + 14);
 					dc.drawLine(X, Y + 12, X + 1, Y + 12);
 				}
 				if (right) {
 					dc.drawLine(X + 12, Y + 7, X + 12, Y + 14);
 				} else {
 					dc.drawLine(X + 12, Y + 12, X + 12, Y + 14);
 					dc.drawLine(X + 13, Y + 12, X + 14, Y + 12);
 				}
 			}
 		} else if (plg[x][y] == :hour){
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillRectangle(scale(x), scale(y), UNIT_SIZE, UNIT_SIZE);
 		} else if (plg[x][y] == :minute) {
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillRectangle(scale(x), scale(y), UNIT_SIZE, UNIT_SIZE);
 		} else if (plg[x][y] == :nil) {
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillRectangle(scale(x), scale(y), UNIT_SIZE, UNIT_SIZE);
 		} else {
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillRectangle(scale(x), scale(y), UNIT_SIZE, UNIT_SIZE);
 		}
 	}

 	hidden function _drawHour(dc, val, pos) {
 		var X = scale(pos[:x]);
 		var Y = scale(pos[:y]);

 		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 		dc.fillRectangle(X, Y, 3 * UNIT_SIZE, 4 * UNIT_SIZE);

 		if (val == 0) {
			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 7, Y + 1],
 				[X + 37, Y + 1],
 				[X + 43, Y + 6],
 				[X + 43, Y + 52],
 				[X + 37, Y + 58],
 				[X + 7, Y + 58],
 				[X + 1, Y + 52],
 				[X + 1, Y + 6],
 				[X + 7, Y + 1]
 			]);
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 9, Y + 7],
 				[X + 35, Y + 7],
 				[X + 35, Y + 52],
 				[X + 9, Y + 52],
 				[X + 9, Y + 7]
 			]);
 		} else if (val == 1) {
			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 4, Y + 1],
 				[X + 26, Y + 1],
 				[X + 26, Y + 52],
 				[X + 35, Y + 52],
 				[X + 35, Y + 35],
 				[X + 37, Y + 33],
 				[X + 41, Y + 33],
 				[X + 43, Y + 35],
 				[X + 43, Y + 55],
 				[X + 40, Y + 58],
 				[X + 4, Y + 58],
 				[X + 1, Y + 56],
 				[X + 1, Y + 52],
 				[X + 18, Y + 52],
 				[X + 18, Y + 7],
 				[X + 3, Y + 7],
 				[X + 1, Y + 5],
 				[X + 1, Y + 4],
 				[X + 4, Y + 1]
 			]);
 		} else if (val == 2) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 3, Y + 1],
 				[X + 37, Y + 1],
 				[X + 43, Y + 6],
 				[X + 43, Y + 28],
 				[X + 35, Y + 33],
 				[X + 9, Y + 33],
 				[X + 9, Y + 51],
 				[X + 35, Y + 51],
 				[X + 43, Y + 53],
 				[X + 43, Y + 56],
 				[X + 40, Y + 58],
 				[X + 1, Y + 58],
 				[X + 1, Y + 31],
 				[X + 7, Y + 26],
 				[X + 34, Y + 26],
 				[X + 34, Y + 8],
 				[X + 5, Y + 8],
 				[X + 1, Y + 6],
 				[X + 1, Y + 3],
 				[X + 3, Y + 1]
 			]);
 		} else if (val == 3) {
			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 4, Y + 1],
 				[X + 37, Y + 1],
 				[X + 43, Y + 6],
 				[X + 43, Y + 25],
 				[X + 40, Y + 29],
 				[X + 40, Y + 30],
 				[X + 43, Y + 34],
 				[X + 43, Y + 53],
 				[X + 37, Y + 58],
 				[X + 4, Y + 58],
 				[X + 1, Y + 56],
 				[X + 1, Y + 54],
 				[X + 5, Y + 51],
 				[X + 35, Y + 51],
 				[X + 35, Y + 33],
 				[X + 13, Y + 33],
 				[X + 10, Y + 31],
 				[X + 10, Y + 28],
 				[X + 13, Y + 26],
 				[X + 35, Y + 26],
 				[X + 35, Y + 9],
 				[X + 5, Y + 9],
 				[X + 1, Y + 7],
 				[X + 1, Y + 3],
 				[X + 4, Y + 1]
 			]);
 		} else if (val == 4) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 6, Y + 1],
 				[X + 9, Y + 1],
 				[X + 11, Y + 3],
 				[X + 11, Y + 33],
 				[X + 29, Y + 33],
 				[X + 29, Y + 10],
 				[X + 32, Y + 7],
 				[X + 34, Y + 7],
 				[X + 37, Y + 10],
 				[X + 37, Y + 34],
 				[X + 41, Y + 34],
 				[X + 41, Y + 38],
 				[X + 37, Y + 40],
 				[X + 37, Y + 56],
 				[X + 34, Y + 58],
 				[X + 32, Y + 58],
 				[X + 29, Y + 55],
 				[X + 29, Y + 40],
 				[X + 6, Y + 40],
 				[X + 4, Y + 3],
 				[X + 6, Y + 1]
 			]);
 		} else if (val == 5) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 10, Y + 1],
 				[X + 40, Y + 1],
 				[X + 43, Y + 3],
 				[X + 43, Y + 5],
 				[X + 39, Y + 8],
 				[X + 17, Y + 8],
 				[X + 17, Y + 26],
 				[X + 36, Y + 26],
 				[X + 43, Y + 31],
 				[X + 43, Y + 53],
 				[X + 37, Y + 58],
 				[X + 13, Y + 58],
 				[X + 1, Y + 53],
 				[X + 1, Y + 50],
 				[X + 5, Y + 48],
 				[X + 14, Y + 52],
 				[X + 35, Y + 52],
 				[X + 35, Y + 33],
 				[X + 10, Y + 33],
 				[X + 10, Y + 1]
 			]);
 		} else if (val == 6) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 4, Y + 1],
 				[X + 10, Y + 1],
 				[X + 13, Y + 3],
 				[X + 13, Y + 7],
 				[X + 9, Y + 7],
 				[X + 9, Y + 32],
 				[X + 39, Y + 32],
 				[X + 43, Y + 35],
 				[X + 43, Y + 56],
 				[X + 40, Y + 58],
 				[X + 4, Y + 58],
 				[X + 1, Y + 56],
 				[X + 1, Y + 3]
 			]);
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 9, Y + 39],
 				[X + 35, Y + 39],
 				[X + 35, Y + 51],
 				[X + 9, Y + 51],
 				[X + 9, Y + 39]
 			]);
 		} else if (val == 7) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 4, Y + 1],
 				[X + 43, Y + 1],
 				[X + 43, Y + 24],
 				[X + 26, Y + 37],
 				[X + 26, Y + 55],
 				[X + 23, Y + 58],
 				[X + 20, Y + 58],
 				[X + 18, Y + 56],
 				[X + 18, Y + 34],
 				[X + 35, Y + 21],
 				[X + 35, Y + 8],
 				[X + 8, Y + 8],
 				[X + 8, Y + 10],
 				[X + 6, Y + 11],
 				[X + 4, Y + 11],
 				[X + 1, Y + 9],
 				[X + 1, Y + 3],
 				[X + 4, Y + 1]
 			]);
 		} else if (val == 8) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 13, Y + 1],
 				[X + 31, Y + 1],
 				[X + 34, Y + 3],
 				[X + 34, Y + 26],
 				[X + 39, Y + 27],
 				[X + 43, Y + 32],
 				[X + 43, Y + 52],
 				[X + 39, Y + 57],
 				[X + 36, Y + 58],
 				[X + 8, Y + 58],
 				[X + 5, Y + 57],
 				[X + 1, Y + 53],
 				[X + 1, Y + 31],
 				[X + 5, Y + 27],
 				[X + 10, Y + 26],
 				[X + 10, Y + 3],
 				[X + 13, Y + 1]
 			]);
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 17, Y + 8],
 				[X + 27, Y + 8],
 				[X + 27, Y + 26],
 				[X + 17, Y + 26],
 				[X + 17, Y + 8]
 			]);
 			dc.fillPolygon([
 				[X + 9, Y + 33],
 				[X + 35, Y + 33],
 				[X + 35, Y + 51],
 				[X + 9, Y + 51],
 				[X + 9, Y + 33]
 			]);
 		} else if (val == 9) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 4, Y + 1],
 				[X + 40, Y + 1],
 				[X + 43, Y + 3],
 				[X + 43, Y + 56],
 				[X + 40, Y + 58],
 				[X + 34, Y + 58],
 				[X + 31, Y + 56],
 				[X + 31, Y + 53],
 				[X + 32, Y + 52],
 				[X + 35, Y + 52],
 				[X + 35, Y + 26],
 				[X + 3, Y + 26],
 				[X + 1, Y + 24],
 				[X + 1, Y + 3],
 				[X + 4, Y + 1]
 			]);
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 9, Y + 8],
 				[X + 35, Y + 8],
 				[X + 35, Y + 20],
 				[X + 9, Y + 20],
 				[X + 9, Y + 8]
 			]);
 		} else {
 		}
 	}

 	hidden function _drawMinute(dc, val, pos) {
 		var X = scale(pos[:x]);
 		var Y = scale(pos[:y]);

 		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 		dc.fillRectangle(X, Y, 2 * UNIT_SIZE, 3 * UNIT_SIZE);

 		if (val == 0) {
			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 4, Y + 1],
 				[X + 25, Y + 1],
 				[X + 23, Y + 4],
 				[X + 23, Y + 40],
 				[X + 25, Y + 43],
 				[X + 4, Y + 43],
 				[X + 1, Y + 40],
 				[X + 1, Y + 4],
 				[X + 4, Y + 1]
 			]);
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 5, Y + 5],
 				[X + 19, Y + 5],
 				[X + 19, Y + 39],
 				[X + 5, Y + 39],
 				[X + 5, Y + 5]
 			]);
 		} else if (val == 1) {
			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 2, Y + 1],
 				[X + 17, Y + 1],
 				[X + 17, Y + 39],
 				[X + 25, Y + 39],
 				[X + 25, Y + 25],
 				[X + 27, Y + 24],
 				[X + 29, Y + 26],
 				[X + 29, Y + 42],
 				[X + 28, Y + 43],
 				[X + 2, Y + 43],
 				[X + 1, Y + 42],
 				[X + 1, Y + 40],
 				[X + 2, Y + 39],
 				[X + 12, Y + 39],
 				[X + 12, Y + 5],
 				[X + 2, Y + 5],
 				[X + 1, Y + 4],
 				[X + 1, Y + 2]
 			]);
 		} else if (val == 2) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 2, Y + 1],
 				[X + 25, Y + 1],
 				[X + 28, Y + 4],
 				[X + 28, Y + 21],
 				[X + 25, Y + 24],
 				[X + 5, Y + 24],
 				[X + 5, Y + 39],
 				[X + 27, Y + 39],
 				[X + 28, Y + 40],
 				[X + 28, Y + 42],
 				[X + 27, Y + 43],
 				[X + 1, Y + 43],
 				[X + 1, Y + 23],
 				[X + 4, Y + 20],
 				[X + 24, Y + 20],
 				[X + 24, Y + 5],
 				[X + 1, Y + 5],
 				[X + 1, Y + 2],
 				[X + 2, Y + 1]
 			]);
 		} else if (val == 3) {
			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 2, Y + 1],
 				[X + 25, Y + 1],
 				[X + 28, Y + 4],
 				[X + 28, Y + 19],
 				[X + 26, Y + 22],
 				[X + 28, Y + 25],
 				[X + 28, Y + 40],
 				[X + 25, Y + 43],
 				[X + 2, Y + 43],
 				[X + 1, Y + 42],
 				[X + 1, Y + 40],
 				[X + 2, Y + 39],
 				[X + 24, Y + 39],
 				[X + 24, Y + 27],
 				[X + 21, Y + 24],
 				[X + 8, Y + 24],
 				[X + 7, Y + 23],
 				[X + 7, Y + 21],
 				[X + 8, Y + 20],
 				[X + 21, Y + 20],
 				[X + 24, Y + 17],
 				[X + 24, Y + 5],
 				[X + 2, Y + 5],
 				[X + 1, Y + 4],
 				[X + 1, Y + 2],
 				[X + 2, Y + 1]
 			]);
 		} else if (val == 4) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 4, Y + 1],
 				[X + 6, Y + 1],
 				[X + 7, Y + 2],
 				[X + 7, Y + 24],
 				[X + 20, Y + 24],
 				[X + 20, Y + 6],
 				[X + 24, Y + 6],
 				[X + 24, Y + 23],
 				[X + 27, Y + 26],
 				[X + 27, Y + 28],
 				[X + 24, Y + 30],
 				[X + 24, Y + 42],
 				[X + 23, Y + 43],
 				[X + 21, Y + 43],
 				[X + 20, Y + 42],
 				[X + 20, Y + 30],
 				[X + 3, Y + 30],
 				[X + 3, Y + 2],
 				[X + 4, Y + 1]
 			]);
 		} else if (val == 5) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 6, Y + 1],
 				[X + 27, Y + 1],
 				[X + 28, Y + 2],
 				[X + 28, Y + 4],
 				[X + 27, Y + 5],
 				[X + 11, Y + 5],
 				[X + 11, Y + 20],
 				[X + 25, Y + 20],
 				[X + 28, Y + 23],
 				[X + 28, Y + 40],
 				[X + 25, Y + 43],
 				[X + 7, Y + 43],
 				[X + 1, Y + 40],
 				[X + 1, Y + 37],
 				[X + 2, Y + 36],
 				[X + 4, Y + 36],
 				[X + 10, Y + 39],
 				[X + 24, Y + 39],
 				[X + 24, Y + 24],
 				[X + 6, Y + 24],
 				[X + 6, Y + 1]
 			]);
 		} else if (val == 6) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 2, Y + 1],
 				[X + 7, Y + 1],
 				[X + 8, Y + 2],
 				[X + 8, Y + 4],
 				[X + 5, Y + 6],
 				[X + 5, Y + 24],
 				[X + 26, Y + 24],
 				[X + 28, Y + 26],
 				[X + 28, Y + 42],
 				[X + 27, Y + 43],
 				[X + 2, Y + 43],
 				[X + 1, Y + 42],
 				[X + 1, Y + 2],
 				[X + 2, Y + 1]
 			]);
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 5, Y + 29],
 				[X + 24, Y + 29],
 				[X + 24, Y + 39],
 				[X + 5, Y + 39],
 				[X + 5, Y + 29]
 			]);
 		} else if (val == 7) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 1, Y + 2],
 				[X + 2, Y + 1],
 				[X + 28, Y + 1],
 				[X + 28, Y + 18],
 				[X + 17, Y + 27],
 				[X + 17, Y + 40],
 				[X + 16, Y + 43],
 				[X + 13, Y + 43],
 				[X + 12, Y + 42],
 				[X + 12, Y + 26],
 				[X + 23, Y + 17],
 				[X + 23, Y + 5],
 				[X + 5, Y + 5],
 				[X + 5, Y + 6],
 				[X + 4, Y + 7],
 				[X + 2, Y + 7],
 				[X + 1, Y + 6],
 				[X + 1, Y + 2]
 			]);
 		} else if (val == 8) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 8, Y + 1],
 				[X + 21, Y + 1],
 				[X + 23, Y + 3],
 				[X + 23, Y + 20],
 				[X + 28, Y + 23],
 				[X + 28, Y + 40],
 				[X + 25, Y + 43],
 				[X + 4, Y + 43],
 				[X + 1, Y + 40],
 				[X + 1, Y + 23],
 				[X + 6, Y + 20],
 				[X + 6, Y + 3],
 				[X + 8, Y + 1]
 			]);
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 11, Y + 5],
 				[X + 18, Y + 5],
 				[X + 18, Y + 20],
 				[X + 11, Y + 20],
 				[X + 11, Y + 5]
 			]);
 			dc.fillPolygon([
 				[X + 5, Y + 24],
 				[X + 24, Y + 24],
 				[X + 24, Y + 39],
 				[X + 5, Y + 39],
 				[X + 5, Y + 24]
 			]);
 		} else if (val == 9) {
 			dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 2, Y + 1],
 				[X + 27, Y + 1],
 				[X + 28, Y + 2],
 				[X + 28, Y + 42],
 				[X + 27, Y + 43],
 				[X + 22, Y + 43],
 				[X + 21, Y + 42],
 				[X + 21, Y + 40],
 				[X + 22, Y + 39],
 				[X + 23, Y + 39],
 				[X + 23, Y + 19],
 				[X + 2, Y + 19],
 				[X + 1, Y + 18],
 				[X + 1, Y + 2],
 				[X + 2, Y + 1]
 			]);
 			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 			dc.fillPolygon([
 				[X + 5, Y + 5],
 				[X + 24, Y + 5],
 				[X + 24, Y + 15],
 				[X + 5, Y + 15],
 				[X + 5, Y + 5]
 			]);
 		} else {
 		}
 	}
 }