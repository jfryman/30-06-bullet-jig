# Process

Getting from the model to marked cartridges.

```mermaid
flowchart LR
    SCAD["bullet-jig.scad"] -->|openscad -D| STL["stl/*.stl"]
    STL --> PRINT["Print<br/>Prusa XL"]
    PRINT --> FA["First-article check"]
    FA -->|pass| SETUP["Square, tape, focus,<br/>measure real pitch"]
    FA -->|fail| PRINT
    SETUP --> RUN["Batch run<br/>side 1, flip, side 2"]
    SCAD --> VER["verify.scad<br/>must render empty"]
```

## Files

- [printing-and-machines.md](printing-and-machines.md) - machine budgets, print
  settings, regenerating STLs
- [laser-setup-and-batch.md](laser-setup-and-batch.md) - setting up the P2 and
  running a batch
- [verification.md](verification.md) - the automated fit test and the
  first-article check

## Related

- [../fixture/registration.md](../fixture/registration.md)
