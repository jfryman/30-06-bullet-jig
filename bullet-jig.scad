// =============================================================================
//  .30-06 Cartridge Laser-Marking Jig
// =============================================================================
//  A two-part fixture for laser-marking .30-06 Springfield cartridges:
//
//    BASE    - taped and squared to the laser bed once, then left alone.
//    CARRIER - drops into the base, holds N cartridges, lifts out for reloading.
//
//  The cradle is a true negative of the measured SAAMI .30-06 profile, tilted
//  nose-up by the body half-taper so the engraved surface is LEVEL end to end.
//
//  Machines this was dimensioned for:
//    Laser   xTool P2 / P2S  (600 x 308 mm bed)  - cartridges lie along X (600)
//    Printer Prusa XL        (360 x 360 x 360)
//
//  Units: millimetres.
//
//  Written for the cartridges marked in memory of Allen Akin, d. September 8, 2026.
//
//  The cradle profile was taken from "Cartridge.stl", derived from
//  ".30-06 Springfield" by is-serp, https://www.printables.com/model/101907
//  licensed CC BY 4.0. Checked against SAAMI .30-06 Springfield dimensions.
//
//  This jig: CC BY 4.0. See LICENSE and the Credits section of README.md.
// =============================================================================

/* [What to render] */
// carrier = the removable nest block, base = the taped-down tray
part = "both";  // [carrier, base, both, demo, none]

/* [Cartridge fit] */
// Radial gap between cartridge and cradle. 0.35 for new/factory brass,
// raise to 0.50 if you are marking fire-formed (once-fired) cases.
clearance = 0.35;

/* [Nest layout] */
// Cartridges per carrier
nest_count  = 7;
// Centre-to-centre spacing of the cradles
nest_pitch  = 16;
// Solid material outboard of the first and last cradle
side_margin = 7;
// Solid material behind the case head (this face is the axial datum)
head_margin = 10;
// Overall carrier length along the cartridge axis
carrier_len = 104;
// Carrier thickness. Top face sits on the cartridge centreline.
carrier_h   = 10;

/* [Base tray] */
// Carrier pockets across the bed. 1 x 2 = 14 up; 2 x 2 = 28 up (still fits both machines).
pockets_x = 1;
pockets_y = 2;
// Drop-in gap around the carrier, per side
pocket_clr  = 0.4;
// How deep the carrier sinks into the base
pocket_depth = 5;
// Base floor thickness
base_floor  = 3;
// Wall thickness around the pockets
base_wall   = 5;
// Wall between adjacent pockets
divider     = 6;
// Flat tape-down / squaring border outside the walls
flange      = 8;
// 45 degree keyed corner. Breaks all symmetry, so a carrier only seats one way.
key_chamfer = 10;

/* [Markings] */
// Depth of engraved reference lines and numbers
mark_depth  = 0.5;
// Engraving window measured from the case head, along the cartridge
window_from = 6;
window_to   = 46;

/* [Dedication] */
// Engraved into the free flanges of the base. Set either to "" to omit.
// Kept as parameters so anyone reusing this jig can put their own words here.
dedication      = "IN MEMORY OF ALLEN AKIN";
dedication_edge = "SPIRIT IN THE SKY";

/* [Hidden] */
$fn = 48;
nest_fn = 96;
eps = 0.01;

// -----------------------------------------------------------------------------
//  Cartridge profile
// -----------------------------------------------------------------------------
//  [ axial position from case head, radius, extra local relief ]
//
//  Taken from the supplied Cartridge.stl and cross-checked against SAAMI:
//    rim  O12.014   body O11.964 -> O11.204   neck O8.634   COAL 84.84
//
//  The extractor groove is deliberately NOT reproduced. A printed bump in a
//  0.8 mm wide groove would rock the cartridge; instead the rim rides a plain
//  straight bore and the groove is simply left in free air.
//
//  Extra relief is added past the shoulder so that a fire-formed case, or one
//  with no bullet seated at all, still drops in. The cartridge is located by
//  the rim bore and the body cone only - the same two datums a chamber uses.

CART = [
  //  z       r       relief
  [ -0.20,  6.007,  0.00 ],   // head face, 0.2 mm axial clearance
  [  3.40,  6.007,  0.00 ],   // straight rim bore (extractor groove relieved)
  [  3.40,  5.982,  0.00 ],   // case body, head end
  [ 49.00,  5.602,  0.00 ],   // case body, shoulder end
  [ 53.30,  4.317,  0.30 ],   // shoulder / neck junction
  [ 63.35,  4.317,  0.30 ],   // case mouth
  [ 63.35,  3.925,  0.50 ],   // bullet bearing surface
  [ 69.50,  3.753,  0.50 ],
  [ 72.00,  3.584,  0.50 ],
  [ 74.00,  3.387,  0.50 ],
  [ 76.00,  3.175,  0.50 ],
  [ 78.00,  2.834,  0.50 ],
  [ 80.00,  2.464,  0.50 ],
  [ 82.00,  1.948,  0.50 ],
  [ 83.00,  1.567,  0.50 ],
  [ 84.00,  1.009,  0.50 ],
  [ 84.84,  0.300,  0.50 ],
];

// Body half-taper, and the nose-up tilt that cancels it.
body_k    = (5.982 - 5.602) / (49.00 - 3.40);   // 0.0083333 mm/mm
tilt      = atan(body_k);                       // 0.47746 deg

// Height of the levelled engraving surface above the carrier top face,
// with the cartridge settled onto the cradle.
mark_rise = 5.982 + body_k * 3.40 - clearance;

// Relief channel past the bullet ogive, so an over-long round cannot bind and
// so there is somewhere to get a fingertip in from the nose end.
tip_r     = 3.0;
tip_from  = 78;
tip_to    = 88;   // carrier X 98, leaving a solid band out to 104

// Through-slot at the case neck: push a cartridge up from underneath to eject.
eject_from = 54;
eject_to   = 64;
eject_w    = 11;

// -----------------------------------------------------------------------------
//  Helpers
// -----------------------------------------------------------------------------

// Rectangle with the corner at the origin cut off at 45 degrees, optionally
// offset outward by o. Offsetting a 45 degree chamfer slides its ends by
// o*(sqrt(2)-1) along the adjacent edges.
function keyed_rect(sx, sy, c, o = 0) = [
  [ c - 0.41421 * o, -o ],
  [ sx + o,          -o ],
  [ sx + o,          sy + o ],
  [ -o,              sy + o ],
  [ -o,              c - 0.41421 * o ],
];

// Solid of revolution matching the cradle cavity (cartridge + clearance).
module cradle_solid() {
  pts = concat(
    [ [ 0, CART[0][0] ] ],
    [ for (p = CART) [ p[1] + clearance + p[2], p[0] ] ],
    [ [ 0, CART[len(CART) - 1][0] ] ]
  );
  rotate_extrude($fn = nest_fn) polygon(pts);
}

// Everything cut away for one cartridge, expressed in cartridge coordinates
// (+Z along the cartridge axis, origin at the case head) before tilting.
module nest_cavity_local() {
  cradle_solid();
  translate([0, 0, tip_from]) cylinder(h = tip_to - tip_from, r = tip_r);
  // Local +X becomes "down" in carrier space once the nest is rotated, so the
  // slot is driven along +X to break through the carrier floor.
  translate([-eject_w / 2, -eject_w / 2, eject_from])
    cube([eject_w / 2 + carrier_h + 1, eject_w, eject_to - eject_from]);
}

// One nest placed in carrier coordinates: axis along +X, case head at
// head_margin, axis at the carrier top face and rising nose-up by `tilt`.
// Keeping the axis at or above the top face everywhere is what guarantees the
// cartridge is never captured past its own centreline, so it lifts straight out.
module nest_cavity() {
  translate([head_margin, 0, carrier_h])
    rotate([0, 90 - tilt, 0])
      nest_cavity_local();
}

function nest_y(i) = side_margin + nest_pitch / 2 + i * nest_pitch;

// -----------------------------------------------------------------------------
//  Carrier
// -----------------------------------------------------------------------------

carrier_y = nest_count * nest_pitch + 2 * side_margin;

module carrier() {
  P = keyed_rect(carrier_len, carrier_y, key_chamfer);

  difference() {
    union() {
      // 0.8 mm chamfer on the bottom edge so elephant's foot cannot stop the
      // carrier from seating flat in the pocket.
      hull() {
        linear_extrude(eps) offset(delta = -0.8) polygon(P);
        translate([0, 0, 0.8]) linear_extrude(eps) polygon(P);
      }
      translate([0, 0, 0.8]) linear_extrude(carrier_h - 0.8) polygon(P);
    }

    for (i = [0 : nest_count - 1])
      translate([0, nest_y(i), 0]) nest_cavity();

    carrier_markings();
  }
}

module carrier_markings() {
  z = carrier_h - mark_depth;

  // Engraving window: two fine lines at the ends of the usable case body and a
  // heavier one on its centre. They cross the cradles, so they read as dashes
  // between nests - line up the laser to these rather than to nominal numbers,
  // which is what makes print shrinkage irrelevant.
  for (m = [[window_from, 0.5], [window_to, 0.5],
            [(window_from + window_to) / 2, 0.9]])
    translate([head_margin + m[0] - m[1] / 2, -eps, z])
      cube([m[1], carrier_y + 2 * eps, mark_depth + eps]);

  for (i = [0 : nest_count - 1]) {
    // Centreline tick on the solid band behind the case head.
    translate([2, nest_y(i) - 0.4, z]) cube([6, 0.8, mark_depth + eps]);

    // Nest number on the solid band past the nose.
    translate([carrier_len - 3, nest_y(i), z])
      linear_extrude(mark_depth + eps)
        text(str(i + 1), size = 3.5, halign = "center", valign = "center",
             font = "Liberation Sans:style=Bold");
  }
}

// -----------------------------------------------------------------------------
//  Base tray
// -----------------------------------------------------------------------------

pocket_x = carrier_len + 2 * pocket_clr;
pocket_y = carrier_y   + 2 * pocket_clr;

span_x = pockets_x * pocket_x + (pockets_x - 1) * divider;
span_y = pockets_y * pocket_y + (pockets_y - 1) * divider;

base_x = span_x + 2 * base_wall + 2 * flange;
base_y = span_y + 2 * base_wall + 2 * flange;
base_h = base_floor + pocket_depth;

// Pocket origins, measured in the same frame a carrier uses.
function pocket_org(ix, iy) = [ ix * (pocket_x + divider) - pocket_clr,
                                iy * (pocket_y + divider) - pocket_clr ];

module base() {
  difference() {
    union() {
      translate([-base_wall - flange, -base_wall - flange, 0])
        linear_extrude(base_floor)
          polygon(keyed_rect(span_x + 2 * (base_wall + flange),
                             span_y + 2 * (base_wall + flange), key_chamfer));
      translate([-base_wall, -base_wall, 0])
        linear_extrude(base_h)
          polygon(keyed_rect(span_x + 2 * base_wall,
                             span_y + 2 * base_wall, key_chamfer));
    }

    for (ix = [0 : pockets_x - 1], iy = [0 : pockets_y - 1]) {
      o = pocket_org(ix, iy);
      translate([o[0], o[1], base_floor]) {
        // The pocket itself, keyed to match the carrier.
        translate([0, 0, 0])
          linear_extrude(pocket_depth + eps)
            polygon(keyed_rect(pocket_x, pocket_y, key_chamfer));
        // Corner relief, so a slightly bulged carrier corner cannot wedge.
        for (v = keyed_rect(pocket_x, pocket_y, key_chamfer))
          translate([v[0], v[1], -eps])
            cylinder(h = pocket_depth + 3 * eps, r = 1.2, $fn = 16);
      }

      // Window through the floor: saves a lot of print time, and lets you push
      // cartridges up through the carrier's eject slots without unloading it.
      translate([o[0] + 14, o[1] + 14, -eps])
        cube([pocket_x - 28, pocket_y - 28, base_floor + 2 * eps]);

      // Finger notches in the end walls, to lift a loaded carrier out.
      for (e = [-base_wall - eps, pocket_x - eps])
        translate([o[0] + e, o[1] + pocket_y / 2 - 17.5, base_floor])
          cube([base_wall + 2 * eps, 35, pocket_depth + eps]);
    }

    base_markings();
  }
}

module base_markings() {
  translate([span_x / 2, -base_wall - flange / 2, base_floor - mark_depth])
    linear_extrude(mark_depth + eps)
      text(".30-06 JIG  -  SQUARE THIS EDGE",
           size = 4.5, halign = "center", valign = "center",
           font = "Liberation Sans:style=Bold");

  translate([-base_wall - flange / 2, span_y / 2, base_floor - mark_depth])
    rotate([0, 0, 90])
      linear_extrude(mark_depth + eps)
        text("SEAT EACH CARRIER INTO ITS KEYED CORNER",
             size = 4.5, halign = "center", valign = "center",
             font = "Liberation Sans:style=Bold");

  // The two free flanges carry the dedication. Engraved rather than raised, so
  // the base still tapes down dead flat.
  if (dedication != "")
    translate([span_x / 2, span_y + base_wall + flange / 2,
               base_floor - mark_depth])
      linear_extrude(mark_depth + eps)
        text(dedication, size = 5, halign = "center", valign = "center",
             font = "Liberation Sans:style=Bold");

  if (dedication_edge != "")
    translate([span_x + base_wall + flange / 2, span_y / 2,
               base_floor - mark_depth])
      rotate([0, 0, -90])
        linear_extrude(mark_depth + eps)
          text(dedication_edge, size = 5, halign = "center", valign = "center",
               font = "Liberation Sans:style=Bold");
}

// -----------------------------------------------------------------------------
//  Output
// -----------------------------------------------------------------------------

module assembly(show_rounds = false) {
  color("DimGray") base();
  for (ix = [0 : pockets_x - 1], iy = [0 : pockets_y - 1]) {
    o = pocket_org(ix, iy);
    translate([o[0] + pocket_clr, o[1] + pocket_clr, base_floor]) {
      color("Gainsboro") carrier();
      if (show_rounds)
        for (i = [0 : nest_count - 1])
          color("Goldenrod")
            translate([0, nest_y(i), -clearance]) nest_round();
    }
  }
}

module nest_round() {
  translate([head_margin, 0, carrier_h])
    rotate([0, 90 - tilt, 0])
      translate([0, 0, -0.0])
        import("Cartridge.stl");
}

if      (part == "carrier") carrier();
else if (part == "base")    base();
else if (part == "demo")    assembly(true);
else if (part == "both")    assembly(false);

echo(str("carrier  ", carrier_len, " x ", carrier_y, " x ", carrier_h));
echo(str("base     ", base_x, " x ", base_y, " x ", base_h));
echo(str("nests    ", nest_count * pockets_x * pockets_y, " per load"));
echo(str("tilt     ", tilt, " deg"));
echo(str("mark surface above carrier top face  ", mark_rise));
echo(str("mark surface above laser bed         ", base_floor + carrier_h + mark_rise));
