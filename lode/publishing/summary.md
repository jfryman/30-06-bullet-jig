# Publishing

The project is published as an open model. Two obligations attach to that: the
upstream mesh's licence, and the project's own.

- [licensing.md](licensing.md) - licences, attribution, and what may be
  relicensed

## Where it lives

| | |
|---|---|
| Git remote | `git@github.com:jfryman/30-06-bullet-jig.git` (branch `master`) |
| Printables | not yet listed |

Pushes go over SSH. `gh` is not authenticated on this machine, and the HTTPS
remote cannot authenticate non-interactively.

## Repo layout

```
bullet-jig.scad     parametric marking jig, base + carrier
spray-stand.scad    clear-coat drying stand (own model)
display-plate.scad  casing display, drawer + chest-top variants (own model)
verify.scad         automated fit test, must render empty
Cartridge.stl       reference mesh (third-party, CC BY 4.0)
stl/                carrier-7nest, base-14up, base-28up, spray-stand-7nest,
                    display-plate-17up, display-plate-top (+ .3mf for the XL)
docs/               renders (assembly, base plan, carrier)
lode/               this knowledge base (lode/tmp/ is git-ignored)
LICENSE             CC BY 4.0
```

## Related

- [../process/printing-and-machines.md](../process/printing-and-machines.md)
