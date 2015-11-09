using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class PacmanView extends Ui.WatchFace {

	var emptyUnit;
	var movables;

	var playground;

    //! Load your resources here
    function onLayout(dc) {
        playground = new Playground();
        playground.init();

       	emptyUnit = Ui.loadResource(Rez.Drawables.empty_unit);

		movables = new [5];

        var pacman = new Pacman();
        pacman.init(
        	playground,
        	{:x => 7, :y => 6},
        	:right,
        	{
        		:up => Ui.loadResource(Rez.Drawables.pacman_u),
        		:right => Ui.loadResource(Rez.Drawables.pacman_r),
        		:down => Ui.loadResource(Rez.Drawables.pacman_d),
        		:left => Ui.loadResource(Rez.Drawables.pacman_l)
            }
         );
         movables[0] = pacman;

        var ghostRed = new Ghost();
        ghostRed.init(
        	playground,
        	{:x => 3, :y => 9},
        	:right,
        	{
        		:up => Ui.loadResource(Rez.Drawables.ghost_red_u),
        		:right => Ui.loadResource(Rez.Drawables.ghost_red_r),
        		:down => Ui.loadResource(Rez.Drawables.ghost_red_d),
        		:left => Ui.loadResource(Rez.Drawables.ghost_red_l)
        	}
        );
        movables[1] = ghostRed;

        var ghostCyan = new Ghost();
        ghostCyan.init(
        	playground,
        	{:x => 4, :y => 9},
        	:right,
        	{
        		:up => Ui.loadResource(Rez.Drawables.ghost_cyan_u),
        		:right => Ui.loadResource(Rez.Drawables.ghost_cyan_r),
        		:down => Ui.loadResource(Rez.Drawables.ghost_cyan_d),
        		:left => Ui.loadResource(Rez.Drawables.ghost_cyan_l)
        	}
        );
        movables[2] = ghostCyan;

        var ghostBrown = new Ghost();
        ghostBrown.init(
        	playground,
        	{:x => 3, :y => 10},
        	:right,
        	{
        		:up => Ui.loadResource(Rez.Drawables.ghost_brown_u),
        		:right => Ui.loadResource(Rez.Drawables.ghost_brown_r),
        		:down => Ui.loadResource(Rez.Drawables.ghost_brown_d),
        		:left => Ui.loadResource(Rez.Drawables.ghost_brown_l)
        	}
        );
        movables[3] = ghostBrown;

        var ghostPink = new Ghost();
        ghostPink.init(
        	playground,
        	{:x => 4, :y => 10},
        	:right,
        	{
        		:up => Ui.loadResource(Rez.Drawables.ghost_pink_u),
        		:right => Ui.loadResource(Rez.Drawables.ghost_pink_r),
        		:down => Ui.loadResource(Rez.Drawables.ghost_pink_d),
        		:left => Ui.loadResource(Rez.Drawables.ghost_pink_l)
        	}
        );
        movables[4] = ghostPink;
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {

        playground.update(dc);

        for (var i = 0; i < 5; i++) {
        	movables[i].moveToNextPos(dc, emptyUnit);
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
        ghostPink.uninit();
        ghostBrown.uninit();
        ghostCyan.uninit();
        ghostRed.uninit();
        pacman.uninit();
    	playground.unit();
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
}
