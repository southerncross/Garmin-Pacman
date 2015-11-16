using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

// Playground of pacman game
class Playground {
	// Playground map, 2d array actually.
	var plg;

	// Previous hour value. Used for checking whether it has changed.
	var prevHours;

	// Previous minute value. Used for checking whether it has changed.
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

 	// Update playground.
 	// There exist something that need to be updated as time goes by.
 	// For example, time should be checked and updated.
 	//
 	// @param dc[in]   device context which is used for drawing
	// @param lazy[in] in lazy mode, time will not be drew if it equals to previous one
 	// @return
 	function update(dc, lazy) {
 		_drawBackground(dc, lazy);
		_drawTime(dc, lazy);
 	}

	// Return the symbol at specified position.
	//
	// @param pos[in] the position to look at
	// @return symbol
 	function get(pos) {
 		return plg[pos[:x]][pos[:y]];
 	}

	// Set a position with specified symbol.
	//
	// @param pos[in]  the position to be set
	// @param symb[in] the symbol to be set
	// @return
 	function set(pos, symb) {
 		plg[pos[:x]][pos[:y]] = symb;
 	}

	// Draw the background of playground.
	// Since background is stable, so we should not evoke this method
	// every time.
	//
	// @param dc[in]   the device context for drawing
	// @param lazy[in] in lazy mode, background will not be drew
	// @return
 	hidden function _drawBackground(dc, lazy) {
 		if (lazy) {
 			return;
 		}

 		for (var i = 0; i < SCREEN_UNIT; i++) {
 			for (var j = 0; j < SCREEN_UNIT; j++) {
 				_drawUnit(dc, i, j);
 			}
 		}
 	}

 	// Draw time for the watch-face.
 	//
 	// @param dc[in] device context which is used for drawing
 	// @param lazy[in] whether is under lazy mode
 	// @return
 	hidden function _drawTime(dc, lazy) {
 		// Update & draw time.
		var clockTime = Sys.getClockTime();
        var h1 = clockTime.hour / 10;
        var h2 = clockTime.hour % 10;
        var m1 = clockTime.min / 10;
        var m2 = clockTime.min % 10;

        if (!lazy || h1 != prevHours[0]) {
        	_drawHour(dc, h1, 4, 3);
        	prevHours[0] = h1;
        }
        if (!lazy || h2 != prevHours[1]) {
        	_drawHour(dc, h2, 8, 3);
        	prevHours[1] = h2;
        }
        if (!lazy || m1 != prevMinutes[0]) {
        	_drawMinute(dc, m1, 6, 8);
        	prevMinutes[0] = m1;
        }
        if (!lazy || m2 != prevMinutes[1]) {
        	_drawMinute(dc, m2, 9, 8);
        	prevMinutes[1] = m2;
        }
 	}

	// Draw a unit of screen.
	// Actually here we only draw barriers.
	//
	// @param dc[in] the device contex for drawing
	// @param x[in] x coordination of the unit
	// @param y[in] y coordination of the unit
	// @return
 	hidden function _drawUnit(dc, x, y) {
 		if (plg[x][y] == :barrier) {
 			var X = x * UNIT_SIZE;
 			var Y = y * UNIT_SIZE;
 			var c = Gfx.COLOR_DK_BLUE;
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
 					drawLine(dc, c, X, Y, 5, 2, 7, 2);
 					drawLine(dc, c, X, Y, 4, 3, 3, 4);
 					drawLine(dc, c, X, Y, 2, 5, 2, 7);
 				} else {
 					drawLine(dc, c, X, Y, -1, 2, 7, 2);
 				}
 				if (right) {
 					drawLine(dc, c, X, Y, 7, 2, 9, 2);
 					drawLine(dc, c, X, Y, 10, 3, 11, 4);
 					drawLine(dc, c, X, Y, 12, 5, 12, 7);
 				} else {
 					drawLine(dc, c, X, Y, 7, 2, 15, 2);
 				}
 			} else {
 				if (left) {
 					drawLine(dc, c, X, Y, 2, -1, 2, 7);
 				} else {
 					drawLine(dc, c, X, Y, 2, 0, 2, 1);
 					drawLine(dc, c, X, Y, 0, 2, 1, 2);
 				}
 				if (right) {
 					drawLine(dc, c, X, Y, 12, -1, 12, 7);
 				} else {
 					drawLine(dc, c, X, Y, 12, 0, 12, 1);
 					drawLine(dc, c, X, Y, 13, 2, 13, 2);
 				}
 			}
 			if (bottom) {
 				if (left) {
 					drawLine(dc, c, X, Y, 2, 7, 2, 9);
 					drawLine(dc, c, X, Y, 3, 10, 4, 11);
 					drawLine(dc, c, X, Y, 5, 12, 7, 12);
 				} else {
 					drawLine(dc, c, X, Y, -1, 12, 7, 12);
 				}
 				if (right) {
 					drawLine(dc, c, X, Y, 12, 7, 12, 9);
 					drawLine(dc, c, X, Y, 11, 10, 10, 11);
 					drawLine(dc, c, X, Y, 7, 12, 9, 12);
 				} else {
 					drawLine(dc, c, X, Y, 7, 12, 15, 12);
 				}
 			} else {
 				if (left) {
 					drawLine(dc, c, X, Y, 2, 7, 2, 14);
 				} else {
 					drawLine(dc, c, X, Y, 2, 12, 2, 14);
 					drawLine(dc, c, X, Y, 0, 12, 1, 12);
 				}
 				if (right) {
 					drawLine(dc, c, X, Y, 12, 7, 12, 14);
 				} else {
 					drawLine(dc, c, X, Y, 12, 12, 12, 14);
 					drawLine(dc, c, X, Y, 13, 12, 14, 12);
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

 	// Draw the hour.
 	//
 	// @param dc[in] device context which is used for drawing
 	// @param v[in]  value of hour
 	// @param x[in]  offset of x coordination of the hour
 	// @param y[in]  offset of y coordination of the hour
 	// @return
 	hidden function _drawHour(dc, v, x, y) {
 		// We need to scale the unit and get real coordination.
 		var X = scale(x);
 		var Y = scale(y);

 		// Erase the old one.
 		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 		dc.fillRectangle(X, Y, 3 * UNIT_SIZE, 4 * UNIT_SIZE);

 		if (v == 0) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[7, 1],
 				[37, 1],
 				[43, 6],
 				[43, 52],
 				[37, 58],
 				[7, 58],
 				[1, 52],
 				[1, 6],
 				[7, 1]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[9, 7],
 				[35, 7],
 				[35, 52],
 				[9, 52],
 				[9, 7]
 			]);
 		} else if (v == 1) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[4, 1],
 				[26, 1],
 				[26, 52],
 				[35, 52],
 				[35, 35],
 				[37, 33],
 				[41, 33],
 				[43, 35],
 				[43, 55],
 				[40, 58],
 				[4, 58],
 				[1, 56],
 				[1, 52],
 				[18, 52],
 				[18, 7],
 				[3, 7],
 				[1, 5],
 				[1, 4],
 				[4, 1]
 			]);
 		} else if (v == 2) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[3, 1],
 				[37, 1],
 				[43, 6],
 				[43, 28],
 				[35, 33],
 				[9, 33],
 				[9, 51],
 				[35, 51],
 				[43, 53],
 				[43, 56],
 				[40, 58],
 				[1, 58],
 				[1, 31],
 				[7, 26],
 				[34, 26],
 				[34, 8],
 				[5, 8],
 				[1, 6],
 				[1, 3],
 				[3, 1]
 			]);
 		} else if (v == 3) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[4, 1],
 				[37, 1],
 				[43, 6],
 				[43, 25],
 				[40, 29],
 				[40, 30],
 				[43, 34],
 				[43, 53],
 				[37, 58],
 				[4, 58],
 				[1, 56],
 				[1, 54],
 				[5, 51],
 				[35, 51],
 				[35, 33],
 				[13, 33],
 				[10, 31],
 				[10, 28],
 				[13, 26],
 				[35, 26],
 				[35, 9],
 				[5, 9],
 				[1, 7],
 				[1, 3],
 				[4, 1]
 			]);
 		} else if (v == 4) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[6, 1],
 				[9, 1],
 				[11, 3],
 				[11, 33],
 				[29, 33],
 				[29, 10],
 				[32, 7],
 				[34, 7],
 				[37, 10],
 				[37, 34],
 				[41, 34],
 				[41, 38],
 				[37, 40],
 				[37, 56],
 				[34, 58],
 				[32, 58],
 				[29, 55],
 				[29, 40],
 				[4, 40],
 				[4, 3],
 				[6, 1]
 			]);
 		} else if (v == 5) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[10, 1],
 				[40, 1],
 				[43, 3],
 				[43, 5],
 				[39, 8],
 				[17, 8],
 				[17, 26],
 				[36, 26],
 				[43, 31],
 				[43, 53],
 				[37, 58],
 				[13, 58],
 				[1, 53],
 				[1, 50],
 				[5, 48],
 				[14, 52],
 				[35, 52],
 				[35, 33],
 				[10, 33],
 				[10, 1]
 			]);
 		} else if (v == 6) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[4, 1],
 				[10, 1],
 				[13, 3],
 				[13, 7],
 				[9, 7],
 				[9, 32],
 				[39, 32],
 				[43, 35],
 				[43, 56],
 				[40, 58],
 				[4, 58],
 				[1, 56],
 				[1, 3]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[9, 39],
 				[35, 39],
 				[35, 51],
 				[9, 51],
 				[9, 39]
 			]);
 		} else if (v == 7) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[4, 1],
 				[43, 1],
 				[43, 24],
 				[26, 37],
 				[26, 55],
 				[23, 58],
 				[20, 58],
 				[18, 56],
 				[18, 34],
 				[35, 21],
 				[35, 8],
 				[8, 8],
 				[8, 10],
 				[6, 11],
 				[4, 11],
 				[1, 9],
 				[1, 3],
 				[4, 1]
 			]);
 		} else if (v == 8) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[13, 1],
 				[31, 1],
 				[34, 3],
 				[34, 26],
 				[39, 27],
 				[43, 32],
 				[43, 52],
 				[39, 57],
 				[36, 58],
 				[8, 58],
 				[5, 57],
 				[1, 53],
 				[1, 31],
 				[5, 27],
 				[10, 26],
 				[10, 3],
 				[13, 1]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[17, 8],
 				[27, 8],
 				[27, 26],
 				[17, 26],
 				[17, 8]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[9, 33],
 				[35, 33],
 				[35, 51],
 				[9, 51],
 				[9, 33]
 			]);
 		} else if (v == 9) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[4, 1],
 				[40, 1],
 				[43, 3],
 				[43, 56],
 				[40, 58],
 				[34, 58],
 				[31, 56],
 				[31, 53],
 				[32, 52],
 				[35, 52],
 				[35, 26],
 				[3, 26],
 				[1, 24],
 				[1, 3],
 				[4, 1]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[9, 8],
 				[35, 8],
 				[35, 20],
 				[9, 20],
 				[9, 8]
 			]);
 		} else {
 		}
 	}

 	// Draw the minute.
 	//
 	// @param dc[in] device context which is used for drawing
 	// @param v[in]  value of minute
 	// @param x[in]  offset of x coordination of the minute
 	// @param y[in]  offset of y coordination of the minute
 	// @return
 	hidden function _drawMinute(dc, v, x, y) {
 		// We need to scale the unit and get real coordination.
 		var X = scale(x);
 		var Y = scale(y);

 		// Erase the old one.
 		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
 		dc.fillRectangle(X, Y, 2 * UNIT_SIZE, 3 * UNIT_SIZE);

 		if (v == 0) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[4, 1],
 				[20, 1],
 				[23, 4],
 				[23, 40],
 				[20, 43],
 				[4, 43],
 				[1, 40],
 				[1, 4],
 				[4, 1]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[5, 5],
 				[19, 5],
 				[19, 39],
 				[5, 39],
 				[5, 5]
 			]);
 		} else if (v == 1) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[2, 1],
 				[17, 1],
 				[17, 39],
 				[25, 39],
 				[25, 25],
 				[27, 24],
 				[29, 26],
 				[29, 42],
 				[28, 43],
 				[2, 43],
 				[1, 42],
 				[1, 40],
 				[2, 39],
 				[12, 39],
 				[12, 5],
 				[2, 5],
 				[1, 4],
 				[1, 2]
 			]);
 		} else if (v == 2) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[2, 1],
 				[25, 1],
 				[28, 4],
 				[28, 21],
 				[25, 24],
 				[5, 24],
 				[5, 39],
 				[27, 39],
 				[28, 40],
 				[28, 42],
 				[27, 43],
 				[1, 43],
 				[1, 23],
 				[4, 20],
 				[24, 20],
 				[24, 5],
 				[1, 5],
 				[1, 2],
 				[2, 1]
 			]);
 		} else if (v == 3) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[2, 1],
 				[25, 1],
 				[28, 4],
 				[28, 19],
 				[26, 22],
 				[28, 25],
 				[28, 40],
 				[25, 43],
 				[2, 43],
 				[1, 42],
 				[1, 40],
 				[2, 39],
 				[24, 39],
 				[24, 27],
 				[21, 24],
 				[8, 24],
 				[7, 23],
 				[7, 21],
 				[8, 20],
 				[21, 20],
 				[24, 17],
 				[24, 5],
 				[2, 5],
 				[1, 4],
 				[1, 2],
 				[2, 1]
 			]);
 		} else if (v == 4) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[4, 1],
 				[6, 1],
 				[7, 2],
 				[7, 24],
 				[20, 24],
 				[20, 6],
 				[24, 6],
 				[24, 23],
 				[27, 26],
 				[27, 28],
 				[24, 30],
 				[24, 42],
 				[23, 43],
 				[21, 43],
 				[20, 42],
 				[20, 30],
 				[3, 30],
 				[3, 2],
 				[4, 1]
 			]);
 		} else if (v == 5) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[6, 1],
 				[27, 1],
 				[28, 2],
 				[28, 4],
 				[27, 5],
 				[11, 5],
 				[11, 20],
 				[25, 20],
 				[28, 23],
 				[28, 40],
 				[25, 43],
 				[7, 43],
 				[1, 40],
 				[1, 37],
 				[2, 36],
 				[4, 36],
 				[10, 39],
 				[24, 39],
 				[24, 24],
 				[6, 24],
 				[6, 1]
 			]);
 		} else if (v == 6) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[2, 1],
 				[7, 1],
 				[8, 2],
 				[8, 4],
 				[5, 6],
 				[5, 24],
 				[26, 24],
 				[28, 26],
 				[28, 42],
 				[27, 43],
 				[2, 43],
 				[1, 42],
 				[1, 2],
 				[2, 1]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[5, 29],
 				[24, 29],
 				[24, 39],
 				[5, 39],
 				[5, 29]
 			]);
 		} else if (v == 7) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[1, 2],
 				[2, 1],
 				[28, 1],
 				[28, 18],
 				[17, 27],
 				[17, 40],
 				[16, 43],
 				[13, 43],
 				[12, 42],
 				[12, 26],
 				[23, 17],
 				[23, 5],
 				[5, 5],
 				[5, 6],
 				[4, 7],
 				[2, 7],
 				[1, 6],
 				[1, 2]
 			]);
 		} else if (v == 8) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[8, 1],
 				[21, 1],
 				[23, 3],
 				[23, 20],
 				[28, 23],
 				[28, 40],
 				[25, 43],
 				[4, 43],
 				[1, 40],
 				[1, 23],
 				[6, 20],
 				[6, 3],
 				[8, 1]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[11, 5],
 				[18, 5],
 				[18, 20],
 				[11, 20],
 				[11, 5]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[5, 24],
 				[24, 24],
 				[24, 39],
 				[5, 39],
 				[5, 24]
 			]);
 		} else if (v == 9) {
 			fillPolygon(dc, Gfx.COLOR_DK_BLUE, X, Y, [
 				[2, 1],
 				[27, 1],
 				[28, 2],
 				[28, 42],
 				[27, 43],
 				[22, 43],
 				[21, 42],
 				[21, 40],
 				[22, 39],
 				[23, 39],
 				[23, 19],
 				[2, 19],
 				[1, 18],
 				[1, 2],
 				[2, 1]
 			]);
 			fillPolygon(dc, Gfx.COLOR_BLACK, X, Y, [
 				[5, 5],
 				[24, 5],
 				[24, 15],
 				[5, 15],
 				[5, 5]
 			]);
 		} else {
 		}
 	}
 }