# Practices

Patterns this project holds to. Most were paid for once already.

## Verify against the real artefact, not your transcription

`CART` is a hand-transcribed profile. The test that matters intersects the
**actual `Cartridge.stl` mesh** against the cradle, so a typo in the table is
caught by geometry rather than by proofreading. See
[process/verification.md](process/verification.md).

Corollary: when measuring a coarse mesh, evaluate at its **true vertex rings**.
Sampling arbitrary narrow bands returns empty sets and looks like a code bug.

## Manifold is not correct

A valid, watertight, "Simple: yes" render proves only that the solid is
well-formed. An eject slot cutting sideways into neighbouring nests passed every
automated check. **Render an image and look at it** after any change to
placement, rotation, or text.

## Derive constants; never type them

```openscad
body_k = (5.982 - 5.602) / (49.00 - 3.40);
tilt   = atan(body_k);        // not 0.4775
```

If the profile changes, the tilt follows. A typed-in tilt silently decouples from
the geometry it is supposed to cancel.

## Coordinate-frame discipline

Two traps, both hit once:

- **Cartridge z is not carrier X.** They differ by `head_margin`. Convert.
- **After `rotate([0, 90 - tilt, 0])`, local +X is "down"**, not local Y. Work
  out the axis mapping before writing a cube into a rotated frame.

## Empirical alignment beats nominal coordinates

Printed parts shrink. Rather than chase tolerances, engrave fiducials and align
the machine to the **real part**. See
[fixture/registration.md](fixture/registration.md). The corollary is that every
fiducial needs its nominal value documented so a measured deviation is
meaningful.

## Cheap checks gate expensive ones

Order any check procedure so a failure at step 1 saves the work of steps 2-6.
Likewise, structure parts so a likely failure is a **cheap** reprint: `clearance`
and `pocket_clr` problems both reprint the carrier only, never the base.

## Relieve what you cannot print reliably

The extractor groove is not reproduced. A printed bump inside a 0.8 mm groove
would rock the cartridge and destroy the levelness the design depends on.
Prefer a clean relieved datum over a faithful copy of a feature FDM cannot hold.

## Parameterise what a downstream user would change

The dedication is a parameter, not a string literal, because the model is
published for others. Same for `clearance`, `nest_count`, `pockets_*`.

## Assert only what you verified

Do not state a licence version you have not seen; do not quote print times you
have not measured. Fetch canonical legal text rather than reproducing it.

## Build hygiene

- Export with `--export-format=binstl`. ASCII STL is ~3.5x larger.
- Keep the `echo()` dimension block current; it is a free regression check on
  every render.
- Regenerate **all** STLs after a source change, even parts you believe are
  unaffected.

## Related

- [summary.md](summary.md)
- [lode-map.md](lode-map.md)
