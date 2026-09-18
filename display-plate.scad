// =============================================================================
//  .30-06 Casing Display / Organizer Plate
// =============================================================================
//  A loose organizer, not a precision fixture. Fired EMPTY CASINGS (no bullet,
//  ~63 mm to the mouth) are dropped on their sides into a scalloped plate that
//  sits in a mini tool-chest drawer (8.5" / 215.9 mm wide). The plate carries a
//  single bottom ROW of casings at a uniform pitch; because that row sits in
//  fixed cradles, further casings nest in the valleys between them and the pile
//  self-stacks into an open pyramid - cannonball fashion.
//
//  These are party favours: the point is tidy organisation, and every casing
//  must DROP IN AND LIFT OUT FREELY - not snap in. So the fit is deliberately
//  loose:
//
//    * The cradle wraps only the LOWER HALF of the casing (sink = 0), so a
//      casing drops straight down instead of having to be angled past a lip.
//    * Generous radial and axial clearance, sized to swallow print shrink. A
//      test print measured the channel ~1 mm short of nominal (~1.2% shrink on
//      this printer); axial_clr is set well above that. If yours still binds,
//      raise round_clr / axial_clr - this is a slop knob, not a tight fit.
//
//  What keeps the base uniform: casings are laid HEAD-TO-TAIL (alternating
//  direction), so each adjacent pair meets fat-body-to-fat-body, the pitch is
//  the body diameter, and the valleys run level for the next layer to nest.
//  Each cradle is the casing's own profile of revolution, unioned with its
//  mirror, so it seats level whichever way it points.
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

/* [Drawer fit] */
// Interior width of the tool-chest drawer the plate drops into. 8.5" = 215.9.
drawer_w = 215.9;
// Gap left on each side so the plate slides in and out without binding.
fit_clr  = 1.5;

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
// (more retention, but harder to remove) - keep at 0 for party favours.
sink       = 0.0;
// Air gap between adjacent casings in the base row, on top of the touching
// pitch. A little opens the valleys and gives finger room.
stack_gap  = 0.60;

/* [Plate body] */
// Solid plastic under the deepest point of a cradle.
floor      = 2.5;
// Flat solid band front and back of the cradles, for the head marks and so the
// casing ends do not overhang the plate edge.
end_margin = 6;
// Minimum solid wall from the outermost cradle to the side edge of the plate.
edge_wall  = 2.5;

/* [Markings] */
// Depth of engraved numbers, title and dedication.
mark_depth = 0.5;
// Casing number engraved at the end where that casing's HEAD goes. The numbers
// zig front/back down the row, so following them lays the casings head-to-tail
// without thinking. Set false for a plain plate.
number_nests = true;

/* [Dedication] */
// Engraved into the plate. Set to "" to omit. Parametric so anyone reusing this
// can put their own words here.
title      = "DISPLAY BASE  -  .30-06  -  HEAD TO TAIL";
dedication = "IN MEMORY OF ALLEN AKIN";

/* [Hidden] */
$fn = 64;
eps = 0.01;

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

plate_w   = drawer_w - 2 * fit_clr;        // the plate fills the drawer width
pitch     = contact_d + stack_gap;         // centre-to-centre of the base row

// A cradle's mouth at the top surface is widest at the rim band; its half-width
// there sets how close the outer cradle can come to the plate edge.
mouth_hw  = sqrt(pow(rim_r + round_clr, 2) - sink * sink);
first_cx  = edge_wall + mouth_hw;          // centre of the outermost cradle

// Maximise the base row: as many cradles as fit between the side walls, centred.
count     = floor((plate_w - 2 * first_cx) / pitch) + 1;
row_span  = (count - 1) * pitch;
margin_x  = (plate_w - row_span) / 2;      // >= first_cx by construction

plate_depth = channel_len + 2 * end_margin;
plate_th    = sink + (rim_r + round_clr) + floor;  // deepest cradle + solid floor
surf_z      = plate_th;                             // top surface
axis_z      = surf_z - sink;                        // casing axis height

function nest_cx(i) = margin_x + i * pitch;

assert(count >= 1, "no cradle fits the given width - check drawer_w / fit_clr");
assert(pitch >= contact_d - eps,
       "pitch is tighter than the casings can pack - increase stack_gap");
assert(margin_x >= first_cx - eps,
       "outer cradle would breach the side wall - raise edge_wall or fit_clr");
assert(channel_len >= casing_len + 0.5,
       "channel is not comfortably longer than the casing - raise axial_clr");

// -----------------------------------------------------------------------------
//  One cradle: the casing profile of revolution, plus its mirror, laid along Y
// -----------------------------------------------------------------------------
//  Uniform radial offset (round_clr) all round, and the end caps pushed out by
//  axial_clr/2 so the casing never butts the ends - it just drops in.

module case_grown() {
  a = axial_clr / 2;
  pts = concat(
    [ [ 0,               case_z0 - a ] ],   // extended head cap, on axis
    [ [ rim_r + round_clr, case_z0 - a ] ], // straight extension at rim radius
    [ for (p = CASE) [ p[1] + round_clr, p[0] ] ],
    [ [ mouth_r + round_clr, case_z1 + a ] ], // straight extension at mouth radius
    [ [ 0,               case_z1 + a ] ]    // extended mouth cap, on axis
  );
  rotate_extrude($fn = $fn) polygon(pts);   // axis along local Z
}

module lay_case() {
  // Lay the casing along +Y, centred on its own middle so the mirror is clean.
  rotate([-90, 0, 0]) translate([0, 0, -case_mid]) case_grown();
}

module cradle_cut() {
  // The casing can point either way; union both so it seats level whichever way
  // it is laid. Cutting the full revolve is fine - there is no plate above the
  // surface, so it just opens an upward groove.
  translate([0, plate_depth / 2, axis_z]) {
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
    for (i = [0 : count - 1])
      translate([nest_cx(i), 0, 0]) cradle_cut();
    markings();
  }
}

module markings() {
  // Casing number at the end where that casing's HEAD goes - alternating
  // front/back so the row lays itself head-to-tail. Sits in the flat end band.
  if (number_nests)
    for (i = [0 : count - 1]) {
      head_front = (i % 2 == 0);
      y = head_front ? end_margin / 2 : plate_depth - end_margin / 2;
      translate([nest_cx(i), y, surf_z - mark_depth])
        linear_extrude(mark_depth + eps)
          text(str(i + 1), size = 3.5, halign = "center", valign = "center",
               font = "Liberation Sans:style=Bold");
    }

  // Title along the front vertical face.
  if (title != "")
    translate([plate_w / 2, mark_depth, plate_th / 2])
      rotate([90, 0, 0])
        linear_extrude(mark_depth + eps)
          text(title, size = 4.5, halign = "center", valign = "center",
               font = "Liberation Sans:style=Bold");

  // Dedication along the back vertical face.
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
module show_case(i, layer) {
  head_front = (i % 2 == 0);
  color(layer == 0 ? "Goldenrod" : "DarkGoldenrod")
    translate([nest_cx(i), plate_depth / 2, axis_z + layer_rise(layer)])
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
  for (i = [0 : count - 1]) show_case(i, 0);          // base row
  for (i = [0 : count - 2]) show_case(i, 1);          // one nested layer, offset
}

if      (part == "plate") plate();
else if (part == "demo")  demo();

echo(str("casings per base row ", count, "  (pitch ", pitch, " mm)"));
echo(str("plate                ", plate_w, " x ", plate_depth, " x ", plate_th));
echo(str("channel length       ", channel_len, " nominal   (casing ", casing_len,
         ", clears by ", channel_len - casing_len, ")"));
echo(str("radial slop          ", round_clr, "   sink ", sink,
         " (0 = drops straight in)"));
echo(str("layer rise           ", layer_rise(1), " mm per nested layer"));
