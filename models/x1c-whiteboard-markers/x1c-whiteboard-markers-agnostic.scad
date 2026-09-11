// X1 Carbon whiteboard status markers — language-agnostic symbols
// Smaller than US dime (17.91 mm)

$fn = 140;

marker_d = 16.5;      // mm
marker_h = 2.4;       // mm

magnet_d = 6.2;       // optional 6x2 magnet pocket
magnet_depth = 2.1;

emboss_icons = true;  // raised icons for visibility
icon_h = 0.80;

module base_marker() {
    difference() {
        cylinder(h = marker_h, d = marker_d);
        translate([0,0,-0.01])
            cylinder(h = magnet_depth + 0.02, d = magnet_d);
    }
}

// Universal "done" symbol: large checkmark
module done_icon_2d() {
    union() {
        translate([-3.2, -1.5]) rotate(40) square([3.8, 2.0]);
        translate([-0.8, -0.6]) rotate(-43) square([7.4, 2.0]);
    }
}

// Universal "in progress" symbol: circular progress arrow
module progress_icon_2d() {
    union() {
        // open arc
        difference() {
            circle(d = 10.8);
            circle(d = 7.2);
            translate([-8.5, -8.5]) square([17, 6.5]); // opening at bottom
        }
        // arrow head at arc end
        translate([4.2, 2.9]) rotate(28)
            polygon(points=[[0,0],[2.8,1.1],[0.9,3.0]]);
    }
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

module done_marker() { apply_icon(done_icon_2d); }
module progress_marker() { apply_icon(progress_icon_2d); }

// Preview both markers
translate([-11, 0, 0]) done_marker();
translate([ 11, 0, 0]) progress_marker();

// Export single bodies by commenting preview and enabling one:
// done_marker();
// progress_marker();
