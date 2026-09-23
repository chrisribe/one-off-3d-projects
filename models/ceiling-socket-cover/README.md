# Ceiling Socket Cover

Reusable OpenSCAD cover to hide a ceiling socket hole.

## Includes

- `style="simple"`: clean plain cover
- `style="fun"`: cosmic monster relief cover
- `style="kraken"`: chaotic abyss/kraken relief cover

## File

- `ceiling-socket-cover.scad`

## Fit workflow

1. Measure the visible hole diameter in the ceiling.
2. Set `hole_diameter` to that value (mm).
3. Choose mounting:
   - `mount_mode="press_fit"` for tool-less friction tabs
   - `mount_mode="screw_tabs"` for two screw points
   - `mount_mode="locator_ring"` for centering only
4. Set full-disk size with either:
   - `clearance` (auto formula: `cover_diameter = hole_diameter + 2*clearance`), or
   - `cover_diameter_override` for an exact outside diameter.
5. Export STL and test print.

## Default parameters

- `hole_diameter = 68`
- `clearance = 2.0`
- `cover_diameter_override = 0` (0 = use auto formula)
- `cover_thickness = 2.4`
- `mount_mode = "press_fit"`
- `center_wire_hole = false` (full cover default)
- `wire_hole_diameter = 12`

## Notes

- If using an existing socket stem/cable in center, keep `center_wire_hole=true`.
- For tighter holes, increase `press_fit_tab_depth` in 0.2 mm steps.
- For screw mounts, adjust `screw_tab_span` so tabs land on solid ceiling substrate.
- Increase `cover_thickness` to 3.0+ for stiffer large-diameter covers.
- Fun/Kraken reliefs are unioned with a tiny overlap for print reliability.
- Example requested fit: `hole_diameter=115` and `cover_diameter_override=135`.
