# Display plate

A loose organizer, not a pipeline fixture and not a precision cradle. Fired empty
**casings** (no bullet, ~63 mm to the mouth) are dropped on their sides into a
scalloped plate. Each cradle holds one casing; a row seats a base row, and
further casings nest in the valleys between them so the pile self-stacks into an
**open pyramid** (`layer_rise = sqrt(3) * r_centre` ~ 9.95 mm per layer). Source
is `display-plate.scad` at the repo root; one model, two footprints via `variant`.

These are **party favours**: the aim is tidy organisation, so every casing must
drop in and lift out freely - the opposite instinct from the jig. It shares only
the cartridge profile (the [CART](../geometry/cartridge-profile.md) table,
truncated at the case mouth).

## Two variants (`variant`)

| `variant` | Footprint | Rows x count | STL |
|---|---|---|---|
| `drawer` | 8.5" drawer -> `drawer_w - 2*fit_clr` wide, depth snug to one row | 1 x 17 | `stl/display-plate-17up.stl` |
| `top` | 10.75 x 5.75" chest top (`top_w` x `top_d`), minus `pullback` per edge | 2 x 21 | `stl/display-plate-top.stl` |

Both footprints are sized to a **Husky 10 in. Mini Portable Tool Box with 2
Drawers** (Home Depot Model # 690-004-0111, Internet # 339556529, Store SKU #
1014987061): the drawer plate to its 8.5" drawers, the top plate to its
**10.75 x 5.75"** lid (measured by dry fit; the 6.75" first used was wrong).

`drawer` is the default so a bare render reproduces the shipped drawer plate.
`stack_gap` differs (0.60 drawer for finger room, 0.25 top to make the count).

```mermaid
flowchart TB
    V{variant} -->|drawer| DR["8.5 in drawer<br/>1 row x 17, nests into a pyramid"]
    V -->|top| TP["10.75 x 5.75 in lid<br/>2 rows x 21 = 42, single layer"]
```

### The lid lip - why the top is 2 x 21

The lid closes over an inward **lip, `lid_lip = 8` mm on every edge**. Anything
protruding under it stops the lid, so the casings are held `keepout = lid_lip +
lip_clr` back from the lid opening (the plate itself still fills the well). Two
asserts (`lip_gap_x`, `lip_gap_y`) prove the brass clears the lip; the `echo`
reports the margin.

- **Width (10.75", roomy):** count is maximised inside the keepout -> **21** per
  row, clearing the lip by ~4.6 mm.
- **Depth (5.75", tight):** two rows of 63.25 mm casings need 126.5 mm; the clear
  span inside the lip is only ~130 mm. So the rows **pack tight** (`row_pitch =
  casing_len + row_gap`, ~0.5 mm gap, channels may merge at the centre) and centre
  on the lid, clearing the lip by only **~1.5 mm**. `pullback` is small (1 mm) so
  the plate cannot slide far and eat that margin. A single row is the safe
  fallback if the depth margin is unacceptable.

## Loose by design - the slop knobs

The first cut gripped too hard to accept a casing without angling it in. Fixed:

- **`sink = 0`.** The cradle wraps only the **lower half** of the casing, so the
  opening at the surface is the full casing diameter and it drops **straight
  down**. Any positive `sink` grips past the equator (retention, but you must snap
  it in) - keep 0 for party favours.
- **Clearance sized to swallow print shrink.** `round_clr = 0.50` radial;
  `axial_clr = 2.00` extends the channel to **65.55 mm** so it clears the measured
  **63.25 mm** casing by 2.3 mm. A test print came out ~1 mm short of nominal on
  channel length (~1.2 % shrink), so the real margin is ~1.3 mm. Raise
  `round_clr` / `axial_clr` if a printer runs tighter; an assert guards
  `channel_len >= casing_len + 0.5`. The `echo` reports the nominal length for a
  caliper check.

## What keeps a row uniform

**Alternating head-to-tail** cancels the body taper (r 5.982 -> 5.602): each pair
meets fat-body-to-fat-body, the pitch is the body diameter, and the valleys run
level. Packs tighter than one-way (which collides at the rim, O12.014). An assert
guards `pitch >= contact_d`.

**A symmetric negative.** Each cradle is the casing profile of revolution grown by
`round_clr`, end caps pushed out by `axial_clr/2`, laid along Y and unioned with
its mirror (`cradle_cut(cy)`), so a casing seats level whichever way it points.

## Layout

- `count` across the width: drawer maximises inside the side walls, top maximises
  inside the lid keepout; then centred (`nest_cx`).
- Rows front-to-back (`row_cy(j)`, `row_pitch`): the drawer's single row sits at
  `end_margin`; the top's two rows pack tight (`casing_len + row_gap`) and centre
  on the lid. An assert stops the casings themselves overlapping.
- `plate_th = sink + (rim_r + round_clr) + floor` ~ 9.0 mm (thin, since sink 0).

## Markings (`markings` -> `drawer_markings` / `top_markings`)

- **Drawer**: casing numbers in the flat band beyond each casing's head end,
  alternating so they zig and cue the head-to-tail lay; `title` on the front
  face, `dedication` on the back.
- **Top**: a memorial display - **no numbers**. The two rows nearly meet at the
  centre on the short lid, so there is no centre band; `dedication` engraves on
  the **front** margin and `dedication_edge` on the **back** ("IN MEMORY OF ALLEN
  AKIN" / "SPIRIT IN THE SKY", the pair the funeral cartridges carried on opposite
  sides). Engraved (recessed), so being near the edge does not foul the lid lip.

## Print

Flat, base down, **no supports** - the cradles open upward.

A ready-to-print slicer project ships for the top variant:
`stl/display-plate-top.3mf`, a PrusaSlicer project for the **Original Prusa XL**
(multi-tool, 0.4 mm nozzle), sliced **multi-colour** (cream body, orange
lettering) so the two dedications print in a contrasting filament. It carries the
corrected `variant="top"` mesh; the `.stl` beside it is for any other printer.

## Related

- [../geometry/cartridge-profile.md](../geometry/cartridge-profile.md) - the
  `CART` profile this mirrors (truncated at the mouth) and the uniform-offset
  doctrine (here relaxed for a loose fit)
- [spray-stand.md](spray-stand.md) - the other stand-alone companion `.scad`
