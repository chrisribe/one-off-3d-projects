# Ceiling Socket Cover

Reusable OpenSCAD cover to hide a ceiling socket hole.

## Includes

- `style="simple"`: clean plain cover
- `style="fun"`: smiley relief cover (for lols)

## File

- `ceiling-socket-cover.scad`

## Fit workflow

1. Measure the visible hole diameter in the ceiling.
2. Set `hole_diameter` to that value (mm).
3. Keep `clearance` around `2.0` to start (more if the hole edge is rough).
4. Optional: enable `rear_locator_ring` to self-center the cover in the hole.
5. Export STL and test print.

## Default parameters

- `hole_diameter = 68`
- `clearance = 2.0`
- `cover_thickness = 2.4`
- `center_wire_hole = true`
- `wire_hole_diameter = 12`

## Notes

- If using an existing socket stem/cable in center, keep `center_wire_hole=true`.
- Increase `cover_thickness` to 3.0+ for stiffer large-diameter covers.
- Smiley relief is unioned with a tiny overlap for print reliability.
