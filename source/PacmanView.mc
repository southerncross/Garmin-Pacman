using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class PacmanView extends Ui.WatchFace {

	var pacman;
	var ghostRed;
	var ghostCyan;
	var ghostBrown;
	var ghostPink;

	var playground;

    //! Load your resources here
    function onLayout(dc) {
        playground = new Playground();
        playground.init(dc);

        pacman = new Pacman();
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

        ghostRed = new Ghost();
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

        ghostCyan = new Ghost();
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

        ghostBrown = new Ghost();
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

        ghostPink = new Ghost();
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
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        playground.update(dc);

        pacman.moveToNextPos(dc);

        ghostRed.moveToNextPos(dc);
        ghostCyan.moveToNextPos(dc);
        ghostBrown.moveToNextPos(dc);
        ghostPink.moveToNextPos(dc);
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
