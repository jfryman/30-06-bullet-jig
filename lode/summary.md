# Project Summary

A parametric OpenSCAD fixture for laser-marking .30-06 Springfield cartridges in
batches, on two opposing sides. It exists to replace a bed-of-rice proof of
concept with something repeatable enough to run 100-150 pieces. The fixture is
two parts: a **base** that is squared and taped to the laser bed once and left
alone, and **carriers** that drop into keyed pockets in the base, each holding 7
cartridges, lifting out for loading, unloading and flipping. The defining design
problem is that a .30-06 case body is tapered, so a cartridge lying in a plain
cradle presents a marking surface that drops 0.380 mm along its length; the
cradle axis is therefore tilted nose-up by exactly the body half-taper, which
cancels the taper and holds the marking surface level to 0.0061 mm. Target
machines are an xTool P2 (600 x 308 bed) and a Prusa XL (360 x 360). A separate
**spray stand** (`spray-stand.scad`) is the downstream companion: it holds a
carrier's worth of marked rounds nose-down, hung by the shoulder in guide bores,
so a rotating pass of clear coat covers both marked faces at once. The work is
published at github.com/jfryman/30-06-bullet-jig under CC BY 4.0, and is
dedicated to Allen Akin.

See [lode-map.md](lode-map.md) for the full index.

Domain entry points:
- [geometry/summary.md](geometry/summary.md) - profile, tilt, and the invariants
- [fixture/summary.md](fixture/summary.md) - carrier and base parts
- [process/summary.md](process/summary.md) - print, verify, set up, run
- [publishing/summary.md](publishing/summary.md) - licence and attribution
