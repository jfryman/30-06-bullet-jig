include <bullet-jig.scad>
part = "none";
// Real cartridge mesh at its NOMINAL axis position (before it settles by
// `clearance`). There must be `clearance` of gap everywhere, so this
// intersection has to come out empty. Any non-empty result means the cradle
// profile is transcribed too tight somewhere.
intersection() {
  difference() {
    translate([0,0,0.8]) linear_extrude(carrier_h-0.8)
      polygon(keyed_rect(carrier_len, carrier_y, key_chamfer));
    translate([0, nest_y(0), 0]) nest_cavity();
  }
  translate([0, nest_y(0), 0]) nest_round();
}
