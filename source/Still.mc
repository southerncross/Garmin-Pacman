using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class Still {
	var pos;

	function init(pos) {
		self.pos = pos;
	}

	function uninit() {
		pos = null;
	}
}

class Hour extends Still {
	function init(pos) {
		Still.init(pos);
	}

	function uninit() {
		Still.uninit();
	}

	function update(dc) {
		var clockTime = Sys.getClockTime();
	}
}

class Minute {
	function init(pos) {
		still.init(pos);
	}

	function uninit() {
		Still.uninit();
	}

	function update(dc) {
		var clockTime = Sys.getClockTime();
	}
}