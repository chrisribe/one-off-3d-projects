// X1 Carbon whiteboard status markers — high-visibility version
// Constraint: smaller than a US dime (17.91 mm)

$fn = 120;

// Overall size
marker_d = 16.5;      // mm
marker_h = 2.4;       // mm

// Magnet pocket (optional, 6x2 mm magnet)
magnet_d = 6.2;
magnet_depth = 2.1;

// Visibility options
emboss_icons = true;   // true = raised icons (more visible), false = engraved
icon_h = 0.75;         // raised/engraved height/depth

module base_marker() {
    difference() {
        cylinder(h = marker_h, d = marker_d);
        translate([0,0,-0.01])
            cylinder(h = magnet_depth + 0.02, d = magnet_d);
    }
}

module done_icon_2d() {
    // Bigger, thicker checkmark
    union() {
        translate([-3.0, -1.4]) rotate(40) square([3.6, 1.8]);
        translate([-0.7, -0.5]) rotate(-43) square([7.0, 1.8]);
    }
}

module progress_icon_2d() {
    // Bigger dots for distance readability
    for (x = [-4.1, 0, 4.1])
        translate([x,0]) circle(d = 2.7);
}

module apply_icon(icon2d) {
    if (emboss_icons) {
        union() {
            base_marker();
            translate([0, 0, marker_h - 0.01])
                linear_extrude(height = icon_h)
                    icon2d();
        }
    } else {
        difference() {
            base_marker();
            translate([0, 0, marker_h - icon_h])
                linear_extrude(height = icon_h + 0.03)
                    icon2d();
        }
    }
}

module done_marker() {
    apply_icon(done_icon_2d);
}

module progress_marker() {
    apply_icon(progress_icon_2d);
}

// Preview layout
translate([-11, 0, 0]) done_marker();
translate([ 11, 0, 0]) progress_marker();

// Export single bodies by commenting preview and enabling one:
// done_marker();
// progress_marker();
