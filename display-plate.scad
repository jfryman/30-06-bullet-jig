// =============================================================================
//  .30-06 Casing Display / Organizer Plate
// =============================================================================
//  A loose organizer, not a precision fixture. Fired EMPTY CASINGS (no bullet,
//  ~63 mm to the mouth) are dropped on their sides into a scalloped plate. Each
//  cradle holds one casing; a row of cradles seats a base row, and further
//  casings nest in the valleys between them so the pile self-stacks into an open
//  pyramid - cannonball fashion.
//
//  Two footprints, selected by `variant`:
//    * "drawer" - fills a mini tool-chest DRAWER (8.5" wide), a single row -> 17.
//    * "top"    - sits on the tool-chest TOP (10.75" x 6.75"), two rows -> 22 each.
//  Both share every cradle dimension; they differ only in outline and row count.
//
//  These are party favours: every casing must DROP IN AND LIFT OUT FREELY, so
//  the fit is deliberately loose - the opposite instinct from the jig:
//    * The cradle wraps only the LOWER HALF of the casing (sink = 0), so a casing
//      drops straight down instead of being angled past a lip.
//    * Generous radial and axial clearance, sized to swallow print shrink. A test
//      print measured the channel ~1 mm short of nominal (~1.2 % on that printer);
//      axial_clr is set well above that. If yours binds, raise round_clr /
//      axial_clr - these are slop knobs, not a tight fit.
//
//  What keeps a row uniform: casings are laid HEAD-TO-TAIL (alternating), so each
//  adjacent pair meets fat-body-to-fat-body, the pitch is the body diameter, and
//  the valleys run level for the next layer to nest. Each cradle is the casing's
//  own profile of revolution, unioned with its mirror, so it seats level whichever
//  way it points.
//
//  Units: millimetres. Prints flat, base down, no supports (grooves open up).
//
//  Casing profile shared with bullet-jig.scad (CART, truncated at the mouth).
//
//  Written for the cartridges marked in memory of Allen Akin, d. September 8, 2026.
//  This plate: CC BY 4.0. See LICENSE and the Credits section of README.md.
// =============================================================================

/* [What to render] */
// plate = the part to print, demo = plate with a base row + one nested layer
part = "plate";  // [plate, demo]
// drawer = 8.5" drawer, one row.  top = 10.75 x 6.75" chest top, two rows.
variant = "drawer";  // [drawer, top]

/* [Drawer footprint] */
// Interior width of the tool-chest drawer the plate drops into. 8.5" = 215.9.
drawer_w = 215.9;
// Gap left on each side so the plate slides in and out without binding.
fit_clr  = 1.5;

/* [Chest-top footprint] */
// The tool-chest top. 10 3/4" x 6 3/4".
top_w = 273.05;
top_d = 171.45;
// How far the plate is held back from each top edge, so it sits on without
// overhanging. A "bit" pulled back per the spec.
pullback = 3.0;
// Rows laid front-to-back on the top.
top_rows = 2;

/* [Casing fit - the slop knobs] */
// Measured length of a real casing (head face to mouth), for the fit report.
casing_len = 63.25;
// Radial gap between the brass and the cradle wall. Loose on purpose so a casing
// drops in and lifts out; raise it if your printer runs tight.
round_clr  = 0.50;
// Extra channel length beyond the casing profile (split fore and aft). Sized to
// clear the casing even after the printer shrinks the channel a millimetre or so.
axial_clr  = 2.00;
// How far below the plate top the casing AXIS sits. 0 = the cradle wraps exactly
// the lower half, so casings drop straight in. Positive grips past the equator
// (more retention, harder to remove) - keep at 0 for party favours.
sink       = 0.0;

/* [Plate body] */
// Solid plastic under the deepest point of a cradle.
floor      = 2.5;
// Flat solid band at the ends of a row, for the head marks and so casing ends do
// not overhang the plate edge.
end_margin = 6;
// Minimum solid wall from the outermost cradle to the side edge of the plate.
edge_wall  = 2.5;

/* [Markings] */
// Depth of engraved numbers, title and dedication.
mark_depth = 0.5;
// Casing number engraved at the end where that casing's HEAD goes. The numbers
// zig back and forth so following them lays the casings head-to-tail without
// thinking. Set false for a plain plate.
number_nests = true;

/* [Dedication] */
// Engraved into the plate. Set to "" to omit. Parametric so anyone reusing this
// can put their own words here. His cartridges carried his name on one side and
// the song on the other; on the top variant both are engraved down the centre,
// between the two rows. On the drawer variant, `title` runs on the front face and
// `dedication` on the back.
title           = "DISPLAY BASE  -  .30-06  -  HEAD TO TAIL";
dedication      = "IN MEMORY OF ALLEN AKIN";
dedication_edge = "SPIRIT IN THE SKY";

/* [Hidden] */
$fn = 64;
eps = 0.01;

is_top = (variant == "top");

// Air gap between adjacent casings in a row, on top of the touching pitch. The
// drawer wants finger room; the top packs tight to make the row count.
stack_gap = is_top ? 0.25 : 0.60;

// -----------------------------------------------------------------------------
//  Casing geometry (from bullet-jig.scad CART, truncated at the mouth: no bullet)
// -----------------------------------------------------------------------------
//  [ axial position from case head, radius ].  A fired empty casing.

CASE = [
  //  z       r
  [ -0.20,  6.007 ],   // rim / head face   (O12.014, the widest point)
  [  3.40,  6.007 ],   // straight rim bore
  [  3.40,  5.982 ],   // case body, head end
  [ 49.00,  5.602 ],   // case body, shoulder end
  [ 53.30,  4.317 ],   // shoulder / neck junction
  [ 63.35,  4.317 ],   // case mouth        (open end, no bullet)
];

case_z0    = CASE[0][0];
case_z1    = CASE[len(CASE) - 1][0];
profile_len = case_z1 - case_z0;           // 63.55, nominal casing envelope
channel_len = profile_len + axial_clr;     // the actual cut length, with slop
case_mid   = (case_z0 + case_z1) / 2;      // 31.575, the mirror axis
rim_r      = CASE[0][1];                    // 6.007, sets cradle depth & side wall
mouth_r    = CASE[len(CASE) - 1][1];        // 4.317

// Body taper and the radius at the casing centre - the pair of these on two
// alternating neighbours is what they touch on, so it sets the minimum pitch.
body_k    = (5.982 - 5.602) / (49.00 - 3.40);        // 0.0083333 mm/mm
r_centre  = 5.982 - body_k * (case_mid - 3.40);      // ~5.7472
contact_d = 2 * r_centre;                            // ~11.4944, cheek to cheek

// -----------------------------------------------------------------------------
//  Derived layout
// -----------------------------------------------------------------------------

rows      = is_top ? top_rows : 1;
plate_w   = is_top ? top_w - 2 * pullback : drawer_w - 2 * fit_clr;
plate_depth = is_top ? top_d - 2 * pullback     // fill the chest top
                     : channel_len + 2 * end_margin;   // snug to one row

pitch     = contact_d + stack_gap;         // centre-to-centre within a row

// A cradle's mouth at the top surface is widest at the rim band; its half-width
// there sets how close the outer cradle can come to the plate edge.
mouth_hw  = sqrt(pow(rim_r + round_clr, 2) - sink * sink);
first_cx  = edge_wall + mouth_hw;          // centre of the outermost cradle

// Maximise the row: as many cradles as fit between the side walls, then centred.
count     = floor((plate_w - 2 * first_cx) / pitch) + 1;
row_span  = (count - 1) * pitch;
margin_x  = (plate_w - row_span) / 2;      // >= first_cx by construction

// Rows are spread evenly front-to-back, each occupying channel_len of depth.
row_pitch = rows > 1 ? (plate_depth - 2 * end_margin - channel_len) / (rows - 1) : 0;
function row_cy(j) = end_margin + channel_len / 2 + j * row_pitch;

plate_th   = sink + (rim_r + round_clr) + floor;   // deepest cradle + solid floor
surf_z     = plate_th;                             // top surface
axis_z     = surf_z - sink;                        // casing axis height

function nest_cx(i) = margin_x + i * pitch;

assert(count >= 1, "no cradle fits the given width - check the footprint");
assert(pitch >= contact_d - eps,
       "pitch is tighter than the casings can pack - increase stack_gap");
assert(margin_x >= first_cx - eps,
       "outer cradle would breach the side wall - raise edge_wall or pull back more");
assert(channel_len >= casing_len + 0.5,
       "channel is not comfortably longer than the casing - raise axial_clr");
assert(rows < 2 || row_pitch >= channel_len - eps,
       "rows overlap front-to-back - deepen the plate or drop a row");

// -----------------------------------------------------------------------------
//  One cradle: the casing profile of revolution, plus its mirror, laid along Y
// -----------------------------------------------------------------------------
//  Uniform radial offset (round_clr) all round, and the end caps pushed out by
//  axial_clr/2 so the casing never butts the ends - it just drops in.

module case_grown() {
  a = axial_clr / 2;
  pts = concat(
    [ [ 0,                 case_z0 - a ] ],   // extended head cap, on axis
    [ [ rim_r + round_clr, case_z0 - a ] ],   // straight extension at rim radius
    [ for (p = CASE) [ p[1] + round_clr, p[0] ] ],
    [ [ mouth_r + round_clr, case_z1 + a ] ], // straight extension at mouth radius
    [ [ 0,                 case_z1 + a ] ]     // extended mouth cap, on axis
  );
  rotate_extrude($fn = $fn) polygon(pts);   // axis along local Z
}

module lay_case() {
  // Lay the casing along +Y, centred on its own middle so the mirror is clean.
  rotate([-90, 0, 0]) translate([0, 0, -case_mid]) case_grown();
}

module cradle_cut(cy) {
  // The casing can point either way; union both so it seats level whichever way
  // it is laid. Cutting the full revolve is fine - there is no plate above the
  // surface, so it just opens an upward groove.
  translate([0, cy, axis_z]) {
    lay_case();
    mirror([0, 1, 0]) lay_case();
  }
}

// -----------------------------------------------------------------------------
//  Plate
// -----------------------------------------------------------------------------

module plate() {
  difference() {
    cube([plate_w, plate_depth, plate_th]);
    for (j = [0 : rows - 1], i = [0 : count - 1])
      translate([nest_cx(i), 0, 0]) cradle_cut(row_cy(j));
    markings();
  }
}

module markings() {
  if (is_top) top_markings();
  else        drawer_markings();
}

// The top is a memorial display: no numbers, both dedications engraved down the
// centre in the flat band between the two rows, where they read looking down at
// the piece.
module top_markings() {
  lines = [ for (s = [dedication, dedication_edge]) if (s != "") s ];
  line_h = 8;   // centre-to-centre of the stacked lines, within the mid band
  for (k = [0 : len(lines) - 1])
    translate([plate_w / 2,
               plate_depth / 2 + (k - (len(lines) - 1) / 2) * line_h,
               surf_z - mark_depth])
      linear_extrude(mark_depth + eps)
        text(lines[k], size = 5.5, halign = "center", valign = "center",
             font = "Liberation Sans:style=Bold");
}

module drawer_markings() {
  // Casing number in the flat band just beyond the end where that casing's HEAD
  // goes - alternating within the row so the numbers zig and the row lays itself
  // head-to-tail.
  if (number_nests)
    for (i = [0 : count - 1]) {
      head_front = (i % 2 == 0);
      hy = row_cy(0) + (head_front ? -channel_len / 2 : channel_len / 2);
      ny = hy + (head_front ? -end_margin / 2 : end_margin / 2);
      translate([nest_cx(i), ny, surf_z - mark_depth])
        linear_extrude(mark_depth + eps)
          text(str(i + 1), size = 3.5, halign = "center", valign = "center",
               font = "Liberation Sans:style=Bold");
    }

  // Title along the front vertical face, dedication along the back.
  if (title != "")
    translate([plate_w / 2, mark_depth, plate_th / 2])
      rotate([90, 0, 0])
        linear_extrude(mark_depth + eps)
          text(title, size = 4.5, halign = "center", valign = "center",
               font = "Liberation Sans:style=Bold");

  if (dedication != "")
    translate([plate_w / 2, plate_depth - mark_depth, plate_th / 2])
      rotate([90, 0, 180])
        linear_extrude(mark_depth + eps)
          text(dedication, size = 4, halign = "center", valign = "center",
               font = "Liberation Sans:style=Bold");
}

// -----------------------------------------------------------------------------
//  Output
// -----------------------------------------------------------------------------

// A single casing lying in a cradle, head-to-tail per its number, for the demo.
module show_case(j, i, layer) {
  head_front = (i % 2 == 0);
  color(layer == 0 ? "Goldenrod" : "DarkGoldenrod")
    translate([nest_cx(i), row_cy(j), axis_z + layer_rise(layer)])
      rotate([head_front ? -90 : 90, 0, 0])
        translate([0, 0, -case_mid])
          rotate_extrude($fn = $fn)
            polygon(concat([[0, case_z0]],
                           [for (p = CASE) [p[1], p[0]]],
                           [[0, case_z1]]));
}

// Height a nested layer rises above the one below: two touching cheeks of radius
// r_centre, the next resting in the valley -> sqrt(3) * r_centre.
function layer_rise(layer) = layer * sqrt(3) * r_centre;

module demo() {
  color("Gainsboro") plate();
  for (j = [0 : rows - 1]) {
    for (i = [0 : count - 1]) show_case(j, i, 0);      // base row
    for (i = [0 : count - 2]) show_case(j, i, 1);      // one nested layer
  }
}

if      (part == "plate") plate();
else if (part == "demo")  demo();

echo(str("variant              ", variant, "   rows ", rows, " x ", count,
         " = ", rows * count, " casings in the base"));
echo(str("plate                ", plate_w, " x ", plate_depth, " x ", plate_th,
         "   (pitch ", pitch, ")"));
echo(str("channel length       ", channel_len, " nominal   (casing ", casing_len,
         ", clears by ", channel_len - casing_len, ")"));
echo(str("row spacing          ", row_pitch, " front-to-back"));
echo(str("layer rise           ", layer_rise(1), " mm per nested layer"));
