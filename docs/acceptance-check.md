# First-Article Acceptance Check

Run this once, on the first carrier and base off the printer, **before committing
a batch**. The order matters: the cheap checks gate the expensive ones, so a
failure at step 1 saves you measuring anything below it.

---

## 1. Is the base flat?

Put it on glass or a known-flat surface before anything else. It is a
130.8 × 285.6 × 3 mm plate and it is the one part that *must not rock*.

If a corner lifts, stop - nothing below this is worth measuring, because every
other number is referenced off this plane. Reprint with a brim and more bed
adhesion.

## 2. Does the carrier drop into the pocket?

Clearance is **0.4 mm per side**. It should fall in under its own weight, seat
flat, and show one unmistakable keyed corner.

If it binds, that is shrinkage on the 126 mm axis. Raise `pocket_clr` and reprint
**the carrier only** - the base is unaffected.

## 3. Does a cartridge drop into a cradle and seat against the head stop?

Clearance is **0.35 mm radial**. It should drop in, self-centre, and slide back
against the head stop with no rock.

If it binds, set `clearance = 0.50` and reprint the carrier. Fired brass is
expanded and often needs this. Again, the base is unaffected, so you do not lose
that print.

## 4. Measure the tick span - the one that matters most

| | |
|---|---|
| nest 1 centreline tick | Y = **15.000** mm from the carrier edge |
| nest 7 centreline tick | Y = **111.000** mm |
| span | **96.000** mm across **6** gaps |

**Divide by 6, not 7.** Seven nests, six gaps. Getting this wrong puts you
2.67 mm out per nest, which is a miss, not a rounding error.

Whatever that 96.000 mm actually measures is your real pitch. Program that
number, not the nominal 16.000 - a 126 mm PLA part shrinks a few tenths and the
engraved ticks are there precisely so alignment is empirical.

## 5. Seated apex height, and levelness

Nominal is **18.660 mm** from the underside of the base to the top of the case
body.

Measure it at **both ends** of the marking window, not once. Two equal readings
are your proof that the 0.4775° tilt survived the print. A difference of more
than a few hundredths means the carrier is not sitting flat - go back to step 1.

An over-extruded cradle holds rounds slightly high. That is a fixed focus offset,
not a defect; just set focus from the measured value rather than the nominal one.

## 6. Eject slot

Push a round up from underneath, through the base window and the carrier's neck
slot. Confirms the slots cleared and that the windows line up.

---

## Reference numbers

| | |
|---|---|
| Cradle tilt | 0.477454° nose-up |
| Marking surface above carrier top face | 5.660 mm |
| Marking surface above laser bed | 18.660 mm |
| Marking window | 6 – 46 mm from the case head |
| Window centreline (heavy engraved line) | 36 mm from the carrier head-end face |
| Nest pitch | 16.000 mm |
| Cradle clearance | 0.35 mm radial |
| Pocket clearance | 0.40 mm per side |
| Carrier | 104 × 126 × 10 mm |
| Base, 14-up | 130.8 × 285.6 × 8 mm |
| Base, 28-up | 241.6 × 285.6 × 8 mm |

If steps 1–3 pass, everything remaining is setup rather than geometry.
