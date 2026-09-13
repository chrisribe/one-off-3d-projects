# One-off 3D Projects

Small, practical 3D models and quick prototypes.

## Included

- `models/x1c-whiteboard-markers/`
  - Language-agnostic status markers for whiteboard use
  - Sized under a US dime in width
  - Variants with magnet press-fit pocket

- `models/ceiling-socket-cover/`
  - Reusable ceiling hole cover for socket fixtures
  - `simple` and `fun` styles in one parametric SCAD
  - Optional center wire pass-through and rear locator ring

## Project index (future-proof navigation)

- Root page: `index.html` (cards for all projects)
- Registry: `projects/index.json`
- Add one JSON entry per new project to have it appear in the index automatically.

## Interactive web customizer (no build)

- `web/x1c-marker-customizer/index.html`
- Open on GitHub Pages and users can:
  - edit marker params live
  - preview one marker in 3D
  - choose from a curated Font Awesome icon list
  - download STL directly in browser

## Notes

- `.scad` files are editable source models.
- You can still export `.stl` from OpenSCAD for slicing in Bambu Studio.
- Web customizer gives no-install parameter editing + STL download for non-CAD users.
