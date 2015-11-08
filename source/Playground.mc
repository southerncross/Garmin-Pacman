using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class Playground {
	const UNIT = 15;
	const SIZE = 15;
	
	var plg;
	
	function init() {
		// initialize playground
		plg = new [SIZE];
		for (var i = 0; i < SIZE; i++) {
			plg[i] = new [SIZE];
			for (var j = 0; j < SIZE; j++) {
				plg[i][j] = :nil;
			}
		}
	}
	
	// in case of recursive reference problem, 
 	// we need to uninitialize playground explicitly.
	function uninit() {
		itms = null;
		plg = null;
	}
	
	function draw(dc) {
		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
		dc.drawRectangle(50, 50, 20, 20);
	}
	
	function update(dc) {
	}
}