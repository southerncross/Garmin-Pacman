// App constants

// Pixel size of a unit.
// For most of Garmin devices, the size of screen
// is no larger than 218*218 (47524 pixels). Even with this fact,
// keep every pixels in memory is not only memory-wastful, but
// also computation ineffective. Hence we can divide the screen
// into several units which have the size of 15*15 (225 pixels).
// Take the example of a 218*218 screen, now we only need to
// save 218*218/15/15 (about 225) units instead of 218*218.
const UNIT_SIZE = 15;

// Number of units of the screen.
// For most of Garmin devices, the size of screen
// is no larger than 218*218 (47524 pixels). Even with this fact,
// keep every pixels in memory is not only memory-wastful, but
// also computation ineffective. Hence we can divide the screen
// into several units which have the size of 15*15 (225 pixels).
// Take the example of a 218*218 screen, now we only need to
// save 218*218/15/15 (about 225) units instead of 218*218.
const SCREEN_UNIT = 15;