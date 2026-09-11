// X1 Carbon whiteboard status markers
// Size target: smaller than a US dime (17.91 mm)

$fn = 96;

// Core dimensions
marker_d = 16.5;      // mm (smaller than dime)
marker_h = 2.4;       // mm

// Optional magnet pocket (for 6x2 mm magnet)
magnet_d = 6.2;       // mm
magnet_depth = 2.1;   // mm (from bottom)

// Symbol settings
symbol_depth = 0.55;  // engraved depth from top

module base_marker() {
    difference() {
        cylinder(h = marker_h, d = marker_d);

        // Bottom magnet pocket
        translate([0, 0, -0.01])
            cylinder(h = magnet_depth + 0.02, d = magnet_d);
    }
}

// DONE marker: geometric checkmark engraving (font-free)
module done_marker() {
    difference() {
        base_marker();

        translate([0, 0, marker_h - symbol_depth])
            linear_extrude(height = symbol_depth + 0.02)
                union() {
                    translate([-2.1, -0.9, 0]) rotate(38) square([2.0, 1.1]);
                    translate([-0.5, -0.2, 0]) rotate(-42) square([5.0, 1.1]);
                }
    }
}

// IN PROGRESS marker: three dots engraving
module progress_marker() {
    difference() {
        base_marker();

        for (x = [-3, 0, 3]) {
            translate([x, 0, marker_h - symbol_depth - 0.01])
                cylinder(h = symbol_depth + 0.03, d = 1.8);
        }
    }
}

// Uncomment ONE for single export from OpenSCAD GUI:
// done_marker();
// progress_marker();

// Layout preview for both markers side-by-side:
translate([-11, 0, 0]) done_marker();
translate([ 11, 0, 0]) progress_marker();
