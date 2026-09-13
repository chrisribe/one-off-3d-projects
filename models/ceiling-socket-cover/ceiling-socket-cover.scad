// Ceiling socket hole cover (medallion style)
// Reusable parametric design with two options:
// 1) Simple clean cover
// 2) Fun smiley cover (for lols)
//
// Usage:
// - Set style = "simple" or "fun"
// - Tune hole_diameter to your measured ceiling hole
// - Export STL from OpenSCAD

$fn = 160;

// ----- Core fit params -----
style = "simple";          // "simple" or "fun"
hole_diameter = 68;         // measured hole in ceiling (mm)
clearance = 2.0;            // extra coverage beyond hole radius (mm)
cover_thickness = 2.4;      // top plate thickness (mm)
edge_rounding = 0.6;        // small rim rounding visual (mm)

// ----- Optional center pass-through -----
center_wire_hole = false;   // full concealment default (set true only if you need pass-through)
wire_hole_diameter = 12;    // mm

// ----- Alignment nub (optional) -----
rear_locator_ring = false;  // ring on backside that sits slightly in ceiling opening
locator_diameter = hole_diameter - 1.0;
locator_depth = 1.4;
locator_wall = 1.2;

// ----- Fun style params -----
fun_relief_height = 0.8;    // raised smiley depth above plate
fun_face_scale = 0.62;      // relative size of smiley on cover

cover_diameter = hole_diameter + 2 * clearance;

module rounded_disc(d, h, fillet = 0.6) {
  // cheap visual soft edge: stacked cylinders
  union() {
    cylinder(d = d - 2*fillet, h = h);
    translate([0,0,h-fillet]) cylinder(d = d, h = fillet);
    cylinder(d = d, h = fillet);
  }
}

module base_cover() {
  difference() {
    union() {
      rounded_disc(cover_diameter, cover_thickness, edge_rounding);

      if (rear_locator_ring) {
        translate([0,0,-locator_depth])
        difference() {
          cylinder(d = locator_diameter, h = locator_depth);
          cylinder(d = max(0.1, locator_diameter - 2*locator_wall), h = locator_depth + 0.1);
        }
      }
    }

    if (center_wire_hole) {
      translate([0,0,-0.1])
      cylinder(d = wire_hole_diameter, h = cover_thickness + 0.3);
    }
  }
}

module fun_smiley() {
  face_d = cover_diameter * fun_face_scale;
  z0 = cover_thickness - 0.02; // tiny overlap for printable union

  // eyes
  eye_off_x = face_d * 0.18;
  eye_off_y = face_d * 0.12;
  eye_d = face_d * 0.09;

  // smile arc via ring segment subtraction
  smile_outer = face_d * 0.30;
  smile_inner = face_d * 0.23;

  union() {
    // outer circle ring
    translate([0,0,z0])
    difference() {
      cylinder(d = face_d, h = fun_relief_height);
      translate([0,0,-0.05]) cylinder(d = face_d * 0.86, h = fun_relief_height + 0.1);
    }

    // eyes
    translate([-eye_off_x, eye_off_y, z0]) cylinder(d = eye_d, h = fun_relief_height);
    translate([ eye_off_x, eye_off_y, z0]) cylinder(d = eye_d, h = fun_relief_height);

    // smile
    translate([0, -face_d*0.02, z0])
    intersection() {
      difference() {
        cylinder(d = smile_outer*2, h = fun_relief_height);
        translate([0,0,-0.05]) cylinder(d = smile_inner*2, h = fun_relief_height + 0.1);
      }
      // keep lower half only
      translate([0, -smile_outer*0.65, -0.05])
      cube([smile_outer*2.2, smile_outer*1.2, fun_relief_height + 0.1], center = true);
    }
  }
}

module simple_style() {
  base_cover();
}

module fun_style() {
  union() {
    base_cover();
    fun_smiley();
  }
}

if (style == "fun") {
  fun_style();
} else {
  simple_style();
}
