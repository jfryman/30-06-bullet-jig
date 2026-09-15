# Terminology

Domain language for this project. Cartridge anatomy first, then fixture parts.

## Cartridge anatomy

- **Cartridge** - the complete round: case + primer + powder + bullet. The whole
  thing is what gets marked. Colloquially called "the bullet" in conversation.
- **Bullet** - strictly, only the projectile seated in the case mouth. Not the
  marking surface.
- **Case** - the brass body. Its outer wall is the marking surface.
- **Case head** - the flat base of the cartridge. The axial datum for everything.
- **Rim** - the flange at the head, O12.014 on .30-06. Rides the rim bore.
- **Extractor groove** - the narrow turned groove just ahead of the rim.
  Deliberately not reproduced in the cradle; see
  [geometry/cartridge-profile.md](geometry/cartridge-profile.md).
- **Case body** - the long, slightly tapered section, O11.964 -> O11.204. This
  is the only part that gets marked.
- **Shoulder** - the cone where the body steps down to the neck, at z=49.
- **Neck** - the parallel section gripping the bullet, O8.634.
- **Case mouth** - the open end of the neck, z=63.35.
- **Ogive** - the curved nose of the bullet.
- **COAL** - Cartridge Overall Length. 84.84 mm max for .30-06 per SAAMI.
- **SAAMI** - the US standards body whose published dimensions the measured
  profile was cross-checked against.
- **Fire-formed** - a case that has been fired, so expanded to chamber size.
  Slightly larger than factory; needs more cradle clearance.
- **Headstamp** - markings on the case head. Not used for indexing.

## Fixture parts

- **Base** (or base tray) - the part taped and squared to the laser bed once,
  then left alone. Holds carriers in keyed pockets.
- **Carrier** - the removable block holding 7 cartridges, dropping into a base
  pocket. Several are printed so one loads while another is under the laser.
- **Nest** - one cartridge position in a carrier.
- **Cradle** - the cavity of one nest; a true negative of the cartridge profile.
- **Apex line** - the topmost line along the cartridge, where the beam lands.
  Holding this level is the point of the tilt.
- **Marking window** - the usable span of case body, 6-46 mm from the case head.
- **Head stop** - the wall the case head butts against; the axial datum.
- **Rim bore** - the straight section of cradle the rim rides in.
- **Eject slot** - through-slot at the neck; push a round up from underneath.
- **Tip channel** - relief past the bullet nose so an over-long round cannot bind.
- **Key corner** - the 45 degree chamfer that makes a carrier seat one way only.
- **Flange** - the flat border of the base, for taping down and squaring.
- **Fiducial / tick** - engraved centreline mark used to align the laser to the
  real printed part rather than to nominal coordinates.
- **Pitch** - nest centre-to-centre spacing, 16.000 mm nominal.

## Process

- **Laser spray / marking spray** - CerMark-type coating that bonds to metal
  under a CO2 beam. Applied before loading, never on the jig.
- **Fast axis** - the laser's raster direction (X on the P2). Text runs along it.
- **First article** - the first part off the printer, checked before a batch.
