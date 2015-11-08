using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

function getDirection(pos, newPos) {
    // TODO
    return :right;
}

class Movable {
    var pos;
    var dir;
    var plg;

    function init(plg, pos, dir) {
       self.plg = plg;
       self.pos = pos;
       self.dir = dir;
   }

   function uninit() {
       pos = null;
       dir = null;
       plg = null;
   }
}

class Pacman extends Movable {
    var bm;

    function init(plg, pos, dir, bm) {
       Movable.init(plg, pos, dir);
       self.bm = bm;
   }

   function uninit() {
       bm = null;
       Movable.uninit();
   }

   function moveToNextPos(dc) {
       var nextPos = findNextPos();
       dir = getDirection(pos, nextPos);
       erase(dc);
       pos = nextPos;
       draw(dc);
   }

   hidden function erase(dc) {
       dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
       dc.drawRectangle(pos[:x] * UNIT, pos[:y] * UNIT, UNIT, UNIT);
   }

   hidden function draw(dc) {
       dc.drawBitmap(pos[:x] * UNIT, pos[:y] * UNIT, bm[dir]);
   }

   hidden function findNextPos() {
       return {
           :x => (pos[:x] + 1) % 15,
           :y => (pos[:y] + 1) % 15
       };
   }
}

class Ghost extends Movable {
    var bm;

    function init(plg, pos, dir, bm) {
       Movable.init(plg, pos, dir);
       self.bm = bm;
   }

   function uninit() {
       bm = null;
       Movable.uninit();
   }

   function moveToNextPos(dc) {
       var nextPos = findNextPos();
       dir = getDirection(pos, nextPos);
       erase(dc);
       pos = nextPos;
       draw(dc);
   }

   hidden function erase(dc) {
       dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
       dc.drawRectangle(pos[:x] * UNIT, pos[:y] * UNIT, UNIT, UNIT);
   }

   hidden function draw(dc) {
       dc.drawBitmap(pos[:x] * UNIT, pos[:y] * UNIT, bm[dir]);
   }

   hidden function findNextPos() {
       return {
           :x => (pos[:x] + 1) % 15,
           :y => (pos[:y] + 1) % 15
       };
   }
}