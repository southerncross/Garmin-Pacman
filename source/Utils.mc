// Scale the coordination.
// Since we divide the whole map into several units, so we have to scale the
// coordination with the size of unit.
//
// @param c[in] coordination value
// @return scaled screen coordination
function scale(c) {
	return c * UNIT_SIZE;
}