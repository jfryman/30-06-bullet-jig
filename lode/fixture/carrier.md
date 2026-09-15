# Carrier

The removable block holding 7 cartridges. Drops into a keyed base pocket, lifts
out for loading, unloading and flipping.

## Geometry

```openscad
carrier_y = nest_count * nest_pitch + 2 * side_margin;   // 7*16 + 14 = 126
function nest_y(i) = side_margin + nest_pitch / 2 + i * nest_pitch;
```

Size 104 x 126 x 10 mm. Top face sits **on the cartridge centreline** - that is
what makes the nest exactly half-depth.

| Feature | Extent | Purpose |
|---|---|---|
| Head stop | X = 0 .. 9.8 | Solid band; case head butts it. Axial datum. |
| Nest cradle | from X = 9.8 | Profile negative, see [../geometry/cartridge-profile.md](../geometry/cartridge-profile.md) |
| Eject slot | cartridge z 54..64 | Through-slot at the neck; push rounds up from below |
| Tip channel | cartridge z 78..88 | Relief past the nose, r = 3.0 |
| Solid band | X = 98 .. 104 | Carries the nest numbers |
| Bottom chamfer | 0.8 mm | Defeats elephant's foot so it seats flat in the pocket |

```mermaid
flowchart LR
    HS["Head stop<br/>X 0-9.8"] --> W1["Window start<br/>16"]
    W1 --> WC["Window centre<br/>36 (heavy line)"]
    WC --> W2["Window end<br/>56"]
    W2 --> EJ["Eject slot<br/>64-74"]
    EJ --> TC["Tip channel<br/>88-98"]
    TC --> NUM["Nest numbers<br/>98-104"]
```

## Engraved markings

All cut `mark_depth = 0.5` into the top face:

- **Three transverse reference lines** at 6, 26 and 46 mm from the case head
  (the heavy one at 26 is the window centre). They cross the cradles, so they
  read as **dashes between nests**.
- **A centreline tick per nest** on the head-end solid band, X = 2..8.
- **A nest number per nest** on the tip-end solid band, X ~ 101.

These exist so the laser is aligned to the real printed part. See
[registration.md](registration.md).

## Invariants

- Top face is the parting plane at the cartridge centreline. Do not thicken the
  carrier without moving the nest axis with it.
- No supports, cradles facing up - guaranteed by
  [../geometry/lift-out-invariant.md](../geometry/lift-out-invariant.md).
- Anything cut past `tip_to` must leave the X 98..104 band solid or the nest
  numbers land in mid-air. `tip_to` is in **cartridge z**; carrier X is
  `head_margin + z`, so `tip_to = 88` puts the channel end at X = 98.

## Lessons learned

Cartridge z and carrier X differ by `head_margin`. Conflating them once pushed
the tip channel 4 mm past the end face. Always convert.

## Related

- [base-tray.md](base-tray.md)
- [registration.md](registration.md)
