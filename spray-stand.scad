// =============================================================================
//  .30-06 Cartridge Clear-Coat Spray Stand
// =============================================================================
//  A companion to the laser-marking jig. After a batch is marked, the rounds
//  are stood NOSE-DOWN in this stand and clear-coated (rattle-can topcoat over
//  the CerMark). Standing vertical means one rotating pass coats the whole
//  circumference, so BOTH marked sides are covered without a flip-and-redry.
//
//  Each round drops NOSE-FIRST into a bore. The slender bullet and neck lead in;
//  the SHOULDER (the wide-to-narrow cone at z 49-53 from the head, which is also
//  the .30-06 headspace datum) catches on the bore lip as a self-centring axial
//  stop, while the neck stays captured in the bore below and cannot cock over.
//  The head and the whole marking window stand straight up, in free air.
//
//  Nose-down, not nose-up, because a round balanced head-down on its rim is a
//  tall inverted pendulum and tips at a touch. Hanging by the shoulder with the
//  neck guided in a bore is stable and self-righting.
//
//  Units: millimetres.  Prints flat, base down, no supports.
//
//  Cartridge dimensions shared with bullet-jig.scad (the CART profile).
//
//  Written for the cartridges marked in memory of Allen Akin, d. September 8, 2026.
//  This stand: CC BY 4.0. See LICENSE and the Credits section of README.md.
// =============================================================================

/* [What to render] */
// stand = the part to print, demo = stand with rounds stood in it
part = "stand";  // [stand, demo]

/* [Nest fit] */
// Radial gap between the case neck and the guide bore. Smaller = less wobble,
// larger = drops in more freely (and tolerates overspray on the neck).
neck_clr  = 0.4;
// Countersink funnel at the bore mouth: leads the nose in and forms the seat lip.
cs_mouth_r = 6.5;
cs_depth   = 3;

/* [Nest layout] */
// One carrier's worth.
nest_count  = 7;
// Centre-to-centre spacing. Wide enough to spray around each and keep wet
// bodies from touching.
nest_pitch  = 26;
// Solid deck outboard of the end seats, along the row.
end_margin  = 8;
// Solid deck fore and aft of the seat centreline.
side_margin = 10;

/* [Deck and stand] */
// Deck plate thickness. The guide bore runs through it; deeper = longer neck
// guide (steadier) but more plastic.
deck_h   = 18;
// Skirt wall thickness.
skirt_w  = 3;
// Air gap left below the bullet tip, so it hangs clear of the bench. The skirt
// height is sized from this automatically.
tip_clr  = 3;

/* [Markings] */
// Depth of engraved title, numbers and dedication.
mark_depth = 0.5;

/* [Dedication] */
// Engraved into the deck. Set to "" to omit. Kept parametric so anyone reusing
// this stand can put their own words here.
title      = "CLEAR-COAT STAND  -  .30-06  -  NOSE DOWN";
dedication = "IN MEMORY OF ALLEN AKIN";

/* [Hidden] */
$fn = 64;
eps = 0.01;

// -----------------------------------------------------------------------------
//  Cartridge geometry the seat depends on (from bullet-jig.scad CART)
// -----------------------------------------------------------------------------
//  Shoulder cone: r 5.602 at z 49  ->  r 4.317 at z 53.3 (neck).
//  Neck r 4.317 (O8.634).  Tip at z 84.84.  Marking window ends at z 46.

neck_r  = 4.317;
sh_z1   = 49.00;  sh_r1 = 5.602;   // shoulder, body end
sh_z2   = 53.30;  sh_r2 = 4.317;   // shoulder, neck end
tip_zfh = 84.84;  window_to = 46;

// -----------------------------------------------------------------------------
//  Derived geometry
// -----------------------------------------------------------------------------

bore_r = neck_r + neck_clr;

// Axial position (from the case head) where the shoulder cone reaches bore_r and
// so catches on the bore lip. This is where the round seats.
seat_zfh = sh_z1 + (bore_r - sh_r1) * (sh_z2 - sh_z1) / (sh_r2 - sh_r1);

// Deck footprint. Seats in a single row along X, centred in Y.
deck_x = 2 * end_margin  + (nest_count - 1) * nest_pitch + 2 * cs_mouth_r;
deck_y = 2 * side_margin + 2 * cs_mouth_r;

// The seat lip sits cs_depth below the deck top. Everything from the seat down
// to the tip hangs below; size the skirt so the tip clears the bench.
tip_below_deckbot = (tip_zfh - seat_zfh) - (deck_h - cs_depth);
skirt_h  = tip_below_deckbot + tip_clr;

deck_top = skirt_h + deck_h;
seat_z   = deck_top - cs_depth;   // z of the seat lip

function nest_x(i) = end_margin + cs_mouth_r + i * nest_pitch;
seat_cy = side_margin + cs_mouth_r;

assert(bore_r < sh_r1, "bore must be narrower than the shoulder so the round seats");
assert(seat_zfh > window_to, "seat must sit past the marking window, or it shadows it");

// -----------------------------------------------------------------------------
//  One nest: the funnel + through bore the round drops into
// -----------------------------------------------------------------------------

module nest_cut() {
  // Lead-in funnel; its bottom edge is the self-centring seat lip.
  translate([0, 0, seat_z])
    cylinder(h = cs_depth + eps, r1 = bore_r, r2 = cs_mouth_r);
  // Guide bore for the neck, straight through the deck into the open skirt so
  // coating drains and the bullet hangs free.
  translate([0, 0, skirt_h - eps])
    cylinder(h = deck_h - cs_depth + 2 * eps, r = bore_r);
}

// -----------------------------------------------------------------------------
//  Stand
// -----------------------------------------------------------------------------

module skirt() {
  difference() {
    linear_extrude(skirt_h) square([deck_x, deck_y]);
    // Hollow it, leaving corners solid for rigidity.
    translate([skirt_w, skirt_w, -eps])
      linear_extrude(skirt_h + 2 * eps)
        square([deck_x - 2 * skirt_w, deck_y - 2 * skirt_w]);
    // Windows in the long sides: drainage, airflow, less plastic, finger access.
    for (y = [-eps, deck_y - skirt_w - eps])
      translate([end_margin, y, skirt_h * 0.3])
        cube([deck_x - 2 * end_margin, skirt_w + 2 * eps, skirt_h]);
  }
}

module stand() {
  difference() {
    union() {
      skirt();
      translate([0, 0, skirt_h]) linear_extrude(deck_h) square([deck_x, deck_y]);
    }
    for (i = [0 : nest_count - 1])
      translate([nest_x(i), seat_cy, 0]) nest_cut();
    markings();
  }
}

module markings() {
  // Seat number on the deck top, in front of each bore.
  for (i = [0 : nest_count - 1])
    translate([nest_x(i), side_margin / 2, deck_top - mark_depth])
      linear_extrude(mark_depth + eps)
        text(str(i + 1), size = 4, halign = "center", valign = "center",
             font = "Liberation Sans:style=Bold");

  // Title engraved into the front skirt face.
  if (title != "")
    translate([deck_x / 2, mark_depth, skirt_h / 2])
      rotate([90, 0, 0])
        linear_extrude(mark_depth + eps)
          text(title, size = 4.5, halign = "center", valign = "center",
               font = "Liberation Sans:style=Bold");

  // Dedication engraved on the deck top, along the back margin.
  if (dedication != "")
    translate([deck_x / 2, deck_y - side_margin / 2, deck_top - mark_depth])
      linear_extrude(mark_depth + eps)
        text(dedication, size = 4, halign = "center", valign = "center",
             font = "Liberation Sans:style=Bold");
}

// -----------------------------------------------------------------------------
//  Output
// -----------------------------------------------------------------------------

module demo() {
  color("Gainsboro") stand();
  // Cartridge.stl: axis +Z, head at its own z = 0. Flipped nose-down, then
  // dropped so the shoulder rests on the seat lip.
  for (i = [0 : nest_count - 1])
    color("Goldenrod")
      translate([nest_x(i), seat_cy, seat_z + seat_zfh])
        rotate([180, 0, 0]) import("Cartridge.stl");
}

if      (part == "stand") stand();
else if (part == "demo")  demo();

echo(str("deck         ", deck_x, " x ", deck_y, " x ", deck_h));
echo(str("overall h    ", deck_top));
echo(str("seats        ", nest_count, " at pitch ", nest_pitch));
echo(str("seat at z     ", seat_zfh, " from head (window ends ", window_to, ")"));
echo(str("bullet hangs  ", tip_below_deckbot, " below deck; skirt ", skirt_h));
