using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

// Playground of pacman game
class Playground {
	// Playground map, 2d array actually.
	var plg;

	// Bitmap resource of hour.
	// TODO: Replace it with hardcoded drawing.
	var hBm;
	
	// Bitmap resource of minute.
	// TODO: Replace it with hardcoded drawing.
	var mBm;

	// Remember whether the background has been drew. Since the background
	// (barrier) does not change and thus we do not need to redraw it every
	// time.
	var hasDrewPlg;

	// Initialize function.
	// The built-in initialize function is limited, so we decide to
	// initialize the object explicitly.
	//
	// @return
	function init(hBm, mBm) {
		hasDrewPlg = false;

		self.hBm = hBm;
		self.mBm = mBm;

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
 	// @param dc[in] device context which is used for drawing
 	// @return
 	function update(dc) {
 		if (!hasDrewPlg) {
			_drawPlg(dc);
		}

		// Update & draw time.
		var clockTime = Sys.getClockTime();
        var hour = clockTime.hour;
        var minute = clockTime.min;

		// TODO: Currently we use bitmap resource, though it is memory expensive.
		// I will replae it with hardcode drawing in the future.
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
		// Draw hour, first number.
		dc.fillRectangle(4 * UNIT_SIZE, 3 * UNIT_SIZE, 3 * UNIT_SIZE, 4 * UNIT_SIZE);
		dc.drawBitmap(4 * UNIT_SIZE, 3 * UNIT_SIZE, hBm[hour / 10]);
		// Draw hour, second number.
		dc.fillRectangle(8 * UNIT_SIZE, 3 * UNIT_SIZE, 3 * UNIT_SIZE, 4 * UNIT_SIZE);
		dc.drawBitmap(8 * UNIT_SIZE, 3 * UNIT_SIZE, hBm[hour % 10]);
		// Draw minute, first number.
		dc.fillRectangle(6 * UNIT_SIZE, 8 * UNIT_SIZE, 2 * UNIT_SIZE, 3 * UNIT_SIZE);
		dc.drawBitmap(6 * UNIT_SIZE, 8 * UNIT_SIZE, mBm[minute / 10]);
		// Draw minute, second number.
		dc.fillRectangle(9 * UNIT_SIZE, 8 * UNIT_SIZE, 2 * UNIT_SIZE, 3 * UNIT_SIZE);
		dc.drawBitmap(9 * UNIT_SIZE, 8 * UNIT_SIZE, mBm[minute % 10]);
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
	// @return
 	hidden function _drawPlg(dc) {
 		dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_BLACK);

 		for (var i = 0; i < SCREEN_UNIT; i++) {
 			for (var j = 0; j < SCREEN_UNIT; j++) {
 				_drawUnit(dc, i, j);
 			}
 		}

 		hasDrewPlg = true;
 	}

	// Draw a unit of screen.
	// Actually here we only draw barriers.
	//
	// @param dc[in] the device contex for drawing
	// @param pos[in] position of the unit
	// @return
 	hidden function _drawUnit(dc, pos) {
 		if (plg[pos[:x]][pos[:y]] == :barrier) {
 			var X = pos[:x] * UNIT_SIZE;
 			var Y = pos[:y] * UNIT_SIZE;
 			// Whether the top border of this unit should be drew
 			var top = (y == 0 || plg[x][y - 1] != :barrier);
 			// Whether the bottom border of this unit should be drew
 			var bottom = (y == SCREEN_UNIT - 1 || plg[x][y + 1] != :barrier);
 			// Whether the left border of this unit should be drew
 			var left = (x == 0 || plg[x - 1][y] != :barrier);
 			// Whether the right border of this unit should be drew
 			var right = (x == SCREEN_UNIT - 1 || plg[x + 1][y] != :barrier);

			// No other choice, T-T
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
 		} else if (plg[x][y] == :minute) {
 		} else if (plg[x][y] == :nil) {
 		} else {
 		}
 	}
 }