# Roadmap

Current open work. Delete items as they close; this file is state, not history.

## In progress

- **First-article print and check.** One `carrier-7nest` and one `base-14up` are
  being printed to validate fit and levelness before committing to a batch. The
  check procedure is `docs/acceptance-check.md` in the repo, summarised in
  [../process/verification.md](../process/verification.md). Awaiting caliper
  readings for seated apex height and the nest 1 -> nest 7 tick span.

- **Spray-stand first article.** `stl/spray-stand-7nest.stl` exists but is
  unprinted. Print one and confirm a round drops nose-first and hangs by the
  shoulder (seat at z ~52) with the neck guided steady in the bore, marking
  window standing clear above the deck. If it wobbles, tighten `neck_clr`; if it
  drops too deep or too shallow, that traces to the bore radius vs. the shoulder.
  See [../fixture/spray-stand.md](../fixture/spray-stand.md).

## Decisions pending measurement

- **Cradle clearance.** `clearance = 0.35` suits factory brass. If first-article
  rounds bind, or if the cartridges turn out to be fire-formed, the value goes to
  0.50 and only the carrier is reprinted. See
  [../geometry/cartridge-profile.md](../geometry/cartridge-profile.md).
- **Pocket clearance.** `pocket_clr = 0.4` per side. If the carrier binds in the
  pocket that is shrinkage on the 126 mm axis, not a design error; raise it and
  reprint the carrier.
- **Real nest pitch.** The laser program must use the pitch measured off the
  printed carrier, not 16.000. Until the first article is measured, the program
  pitch is unknown.

## Available but not committed

- **28-up base.** `stl/base-28up.stl` exists (`pockets_x = 2`, 241.6 x 285.6) and
  fits both machines. Doubles throughput per load at the cost of a larger base
  print. Default remains the 14-up base to keep the critical-path print short.

## Not started

- **Printables listing.** The GitHub repo is live; the Printables publication is
  not. Licence and attribution obligations are recorded in
  [../publishing/licensing.md](../publishing/licensing.md).
