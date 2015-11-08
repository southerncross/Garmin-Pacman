using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

// Playground of pacman game
class Playground {
	// Playground map, 2d array actually.
	var plg;

	// Initialize function.
	// The built-in initialize function is limited, so we decide to
	// initialize the object explicitly.
	//
	// @return
	function init() {
		// initialize playground
		plg = new [SCREEN_UNIT];
		for (var i = 0; i < SCREEN_UNIT; i++) {
			plg[i] = new [SCREEN_UNIT];
			for (var j = 0; j < SCREEN_UNIT; j++) {
				plg[i][j] = :nil;
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
 	}
 }