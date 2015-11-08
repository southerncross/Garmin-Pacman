using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

// Calculate moving direction.
//
// @param pos[in] old position
// @param newPos[in] new position
// @return moving direction symbol
function getDirection(pos, newPos) {
    // TODO
    return :right;
}

// Movable indicates anything on the playground that is movable:)
// Every movable object knows the playground map and its position.
class Movable {
    // Position on the playground.
    // For example:
    // {:x => x, :y => y}
    var pos;

    // Moving direction.
    // Could be one of those: symbols:
    // [:up, :right, :down, :left]
    var dir;

    // Playground object.
    // @see Playground
    var plg;

    // Initialize function.
    // The built-in initialize function is limited, so we decide to
    // initialize the object explicitly.
    //
    // @param plg[in] The playground object
    // @param pos[in] The initial position
    // @param dir[in] The initial direction
    // @return
    function init(plg, pos, dir) {
        self.plg = plg;
        self.pos = pos;
        self.dir = dir;
    }

    // Uninitialize function.
    // Monkey-C uses reference-counting mechanism for garbage collection,
    // so it has the problem of recursive reference. To avoid memory leak,
    // we should also call this uninitialize function explicitly to release
    // references.
    //
    // @return
    function uninit() {
        pos = null;
        dir = null;
        plg = null;
    }
}


// Pacman
class Pacman extends Movable {
    // Bitmap resources which is used for draw pacman.
    // It has four pictures for each directions in total.
    //
    // TODO: ConnectIQ will does some differential computation of bitmap color
    // which leads to impure color. We should use vector drawing instead of
    // bitmap.
    var bm;

    // Initialize function.
    // @see Movable
    //
    // @param plg[in] The playground object
    // @param pos[in] The initial position
    // @param dir[in] The initial direction
    // @poram bm[in] The bitmap resources.
    // @return
    function init(plg, pos, dir, bm) {
        Movable.init(plg, pos, dir);
        self.bm = bm;
    }

    // Uninitialize function.
    // @see Movable
    //
    // @return
    function uninit() {
        bm = null;
        Movable.uninit();
    }

    // Moves to next position and draws relative part of screen.
    //
    // @param dc[in] device context which is used for drawing
    // @return
    function moveToNextPos(dc) {
        var nextPos = findNextPos();
        dir = getDirection(pos, nextPos);
        erase(dc);
        pos = nextPos;
        draw(dc);
    }

    // Erase images of current position.
    //
    // @param dc[in] device context which is used for drawing
    // @return
    hidden function erase(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.drawRectangle(pos[:x] * UNIT_SIZE, pos[:y] * UNIT_SIZE, UNIT_SIZE, UNIT_SIZE);
    }

    // Draw images of current position.
    //
    // @pram dc[in] device context which is used for drawing
    // @return
    hidden function draw(dc) {
        dc.drawBitmap(pos[:x] * UNIT_SIZE, pos[:y] * UNIT_SIZE, bm[dir]);
    }

    // Find next position according to current playground situation.
    //
    // @return next position
    hidden function findNextPos() {
		// TODO: not finished yet.
        return {
            :x => (pos[:x] + 1) % 15,
            :y => (pos[:y] + 1) % 15
        };
    }
}


// Ghost
class Ghost extends Movable {
    // Bitmap resources which is used for draw pacman.
    // It has four pictures for each directions in total.
    //
    // TODO: ConnectIQ will does some differential computation of bitmap color
    // which leads to impure color. We should use vector drawing instead of
    // bitmap.
    var bm;

    // Initialize function.
    // @see Movable
    //
    // @param plg[in] The playground object
    // @param pos[in] The initial position
    // @param dir[in] The initial direction
    // @poram bm[in] The bitmap resources.
    // @return
    function init(plg, pos, dir, bm) {
        Movable.init(plg, pos, dir);
        self.bm = bm;
    }

    // Uninitialize function.
    // @see Movable
    //
    // @return
    function uninit() {
        bm = null;
        Movable.uninit();
    }

    // Moves to next position and draws relative part of screen.
    //
    // @param dc[in] device context which is used for drawing
    // @return
    function moveToNextPos(dc) {
        var nextPos = findNextPos();
        dir = getDirection(pos, nextPos);
        erase(dc);
        pos = nextPos;
        draw(dc);
    }

    // Erase images of current position.
    //
    // @param dc[in] device context which is used for drawing
    // @return
    hidden function erase(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.drawRectangle(pos[:x] * UNIT_SIZE, pos[:y] * UNIT_SIZE, UNIT_SIZE, UNIT_SIZE);
    }

    // Draw images of current position.
    //
    // @pram dc[in] device context which is used for drawing
    // @return
    hidden function draw(dc) {
        dc.drawBitmap(pos[:x] * UNIT_SIZE, pos[:y] * UNIT_SIZE, bm[dir]);
    }

    // Find next position according to current playground situation.
    //
    // @return next position
    hidden function findNextPos() {
        return {
            :x => (pos[:x] + 1) % 15,
            :y => (pos[:y] + 1) % 15
        };
    }
}