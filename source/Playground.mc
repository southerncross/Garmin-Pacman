using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

// Playground of pacman game
class Playground {
	// Playground map, 2d array actually.
	var plg;

	var hasDrewPlg;

	// Initialize function.
	// The built-in initialize function is limited, so we decide to
	// initialize the object explicitly.
	//
	// @return
	function init() {
		hasDrewPlg = false;

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
 	}

 	function get(pos) {
 		return plg[pos[:x]][pos[:y]];
 	}

 	function set(pos, ele) {
 		plg[pos[:x]][pos[:y]] = ele;
 	}

 	hidden function _drawPlg(dc) {
 		dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);

 		for (var i = 0; i < SCREEN_UNIT; i++) {
 			for (var j = 0; j < SCREEN_UNIT; j++) {
 				_drawUnit(dc, i, j);
 			}
 		}

 		hasDrewPlg = true;
 	}

 	hidden function _drawUnit(dc, x, y) {
 		if (plg[x][y] == :barrier) {
 			var X = x * UNIT_SIZE;
 			var Y = y * UNIT_SIZE;
 			var top = (y == 0 || plg[x][y - 1] != :barrier);
 			var bottom = (y == SCREEN_UNIT - 1 || plg[x][y + 1] != :barrier);
 			var left = (x == 0 || plg[x - 1][y] != :barrier);
 			var right = (x == SCREEN_UNIT - 1 || plg[x + 1][y] != :barrier);

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