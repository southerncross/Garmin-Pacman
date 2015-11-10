using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class PacmanView extends Ui.WatchFace {

	var movables;

	var playground;

	var prevState;

    //! Load your resources here
    function onLayout(dc) {
    	//Sys.println("onLayout");
        playground = new Playground();

        movables = new [5];

        prevState = :onLayout;
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	//Sys.println("onShow");
    	playground.init();

        var pacman = new Pacman();
        pacman.init(
        	playground,
        	{:x => 7, :y => 6},
        	:right
         );
        movables[0] = pacman;

        var ghostRed = new Ghost();
        ghostRed.init(
        	playground,
        	{:x => 1, :y => 3},
        	:right,
        	Gfx.COLOR_RED
        );
        movables[1] = ghostRed;

        var ghostCyan = new Ghost();
        ghostCyan.init(
        	playground,
        	{:x => 13, :y => 3},
        	:right,
        	0x00FFFF
        );
        movables[2] = ghostCyan;

        var ghostOrange = new Ghost();
        ghostOrange.init(
        	playground,
        	{:x => 1, :y => 11},
        	:right,
        	Gfx.COLOR_ORANGE
        );
        movables[3] = ghostOrange;

        var ghostPink = new Ghost();
        ghostPink.init(
        	playground,
        	{:x => 13, :y => 11},
        	:right,
        	Gfx.COLOR_PINK
        );
        movables[4] = ghostPink;

        prevState = :onShow;
    }

    //! Update the view
    function onUpdate(dc) {
    	//Sys.println("onUpdate");
    	if (prevState == :onHide) {
    		return;
    	}

		if (prevState != :onUpdate) {
			playground.update(dc, true);
		} else {
        	playground.update(dc, false);
        	for (var i = 0; i < 5; i++) {
        		movables[i].moveToNextPos(dc);
        	}
        }

        prevState = :onUpdate;
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    	//Sys.println("onHide");
    	for (var i = 0; i < 5; i++) {
        	movables[i].uninit();
        	movables[i] = null;
        }
        prevState = :onHide;
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	//Sys.println("onExitSleep");
    	prevState = :onExitSleep;
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	//Sys.println("onEnterSleep");
    	prevState = :onEnterSleep;
    }
}
