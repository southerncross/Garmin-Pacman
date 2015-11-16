using Toybox.Graphics as Gfx;


// Scale the coordination.
// Since we divide the whole map into several units, so we have to scale the
// coordination with the size of unit.
//
// @param c[in] coordination value
// @return scaled screen coordination
function scale(c) {
	return c * UNIT_SIZE;
}


// Draw a line.
// Alias call of built-in dc.drawLine.
//
// @param dc[in]    device context
// @param color[in] color of line
// @param X[in]     offset of x coordination
// @param Y[in]     offset of y coordination
// @param x1[in]    x coordination of start point
// @param y1[in]    y coordination of start point
// @param x2[in]    x coordination of end point
// @param y2[in]    y coordination of end point
// @return
function drawLine(dc, color, X, Y, x1, y1, x2, y2) {
	setColor(dc, color);
	dc.drawLine(X + x1, Y + y1, X + x2, Y + y2);
}


// Fill a polygon.
// Alias call of built-in dc.fillPolygon.
//
// @param dc[in]    device context
// @param color[in] color of polygon
// @param X[in]     offset of x coordination
// @param Y[in]     offset of y coordination
// @param pts[in]   array of points of polygon
// @return
function fillPolygon(dc, color, X, Y, pts) {
	var size = pts.size();
	for (var i = 0; i < size; i++) {
		pts[i][0] += X;
		pts[i][1] += Y;
	}
	setColor(dc, color);
	dc.fillPolygon(pts);
}


// Set the color of device context.
// Alias call of built-in dc.setColor.
//
// @param dc[in]    device context
// @param color[in] the color
// @return
function setColor(dc, color) {
	dc.setColor(color, Gfx.COLOR_BLACK);
}


// Calculate the moving direction of the pair of start point and end points.
//
// @param pos[in] old position
// @param newPos[in] new position
// @return moving direction symbol
function getDirection(pos, newPos) {
	var dir = null;

    if (newPos[:y] < pos[:y]) {
    	if (newPos[:y] == 0) {
    		dir = :down;
    	} else {
    		dir = :up;
    	}
    } else if (newPos[:y] > pos[:y]) {
    	if (newPos[:y] == SCREEN_UNIT) {
    		dir = :up;
    	} else {
    		dir = :down;
    	}
    } else if (newPos[:x] < pos[:x]) {
    	if (newPos[:x] == 0) {
    		dir = :right;
    	} else {
    		dir = :left;
    	}
    } else if (newPos[:x] > pos[:x]) {
    	if (newPos[:x] == SCREEN_UNIT) {
    		dir = :left;
    	} else {
    		dir = :right;
    	}
    } else {
    	dir = [:up, :right, :down, :left][Math.rand() % 4];
    }

    return dir;
}


// Calculate the next position along specified direction and return
// the a new position for next moving.
//
// @param pos[in] current position
// @param dir[in] direction for going
// @return next position
function getNextPosition(pos, dir) {
	var nextPos = {};
	if (dir == :up) {
		nextPos[:x] = pos[:x];
		nextPos[:y] = (pos[:y] - 1 + SCREEN_UNIT) % SCREEN_UNIT;
	} else if (dir == :down) {
		nextPos[:x] = pos[:x];
		nextPos[:y] = (pos[:y] + 1 + SCREEN_UNIT) % SCREEN_UNIT;
	} else if (dir == :left) {
		nextPos[:x] = (pos[:x] - 1 + SCREEN_UNIT) % SCREEN_UNIT;
		nextPos[:y] = pos[:y];
	} else if (dir == :right) {
		nextPos[:x] = (pos[:x] + 1 + SCREEN_UNIT) % SCREEN_UNIT;
		nextPos[:y] = pos[:y];
	} else {
		nextPos[:x] = pos[:x];
		nextPos[:y] = pos[:y];
	}

	return nextPos;
}