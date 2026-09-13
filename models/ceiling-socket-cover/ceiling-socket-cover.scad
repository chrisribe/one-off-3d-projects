// Ceiling socket hole cover (medallion style)
// Reusable parametric design with two options:
// 1) Simple clean cover
// 2) Fun cosmic-monster cover (for lols)
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
fun_relief_height = 0.9;    // raised relief depth above plate
fun_face_scale = 0.66;      // relative size of cosmic motif

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

module curve_strip(pts, d, h, z0=0) {
  for (i = [0 : len(pts)-2]) {
    hull() {
      translate([pts[i][0], pts[i][1], z0]) cylinder(d=d, h=h);
      translate([pts[i+1][0], pts[i+1][1], z0]) cylinder(d=d, h=h);
    }
  }
}

module fun_cosmic_monster() {
  face_d = cover_diameter * fun_face_scale;
  z0 = cover_thickness - 0.02; // tiny overlap for printable union
  ring_outer = face_d * 0.50;
  ring_inner = face_d * 0.40;
  spike_len = face_d * 0.11;
  spike_w = face_d * 0.11;

  union() {
    // jagged portal ring
    translate([0,0,z0])
    difference() {
      cylinder(d = ring_outer*2, h = fun_relief_height);
      translate([0,0,-0.05]) cylinder(d = ring_inner*2, h = fun_relief_height + 0.1);
    }

    for (a = [0 : 30 : 330]) {
      rotate([0,0,a])
      translate([ring_outer*0.92, 0, z0])
      linear_extrude(height = fun_relief_height)
      polygon(points = [[0,0], [spike_len, spike_w*0.5], [spike_len, -spike_w*0.5]]);
    }

    // central eye + side eyes + pupil
    translate([0, face_d*0.05, z0]) cylinder(d = face_d * 0.24, h = fun_relief_height);
    translate([-face_d*0.19, face_d*0.09, z0]) cylinder(d = face_d * 0.11, h = fun_relief_height);
    translate([ face_d*0.19, face_d*0.09, z0]) cylinder(d = face_d * 0.11, h = fun_relief_height);
    translate([0, face_d*0.05, z0 + fun_relief_height*0.14]) cylinder(d = face_d * 0.10, h = fun_relief_height*0.90);

    // fangs
    for (sx = [-1, 1]) {
      translate([sx*face_d*0.11, -face_d*0.17, z0])
      linear_extrude(height = fun_relief_height)
      polygon(points = [[0,0],[face_d*0.05,0],[face_d*0.025,-face_d*0.10]]);
    }

    // mirrored tentacles
    t_pts = [
      for (i = [0:7])
      [
        face_d*(0.06 + i*0.06),
        -face_d*(0.10 + i*0.025) + face_d*0.04*sin(i*40)
      ]
    ];
    curve_strip(t_pts, face_d*0.085, fun_relief_height, z0);
    mirror([1,0,0]) curve_strip(t_pts, face_d*0.085, fun_relief_height, z0);
  }
}

module simple_style() {
  base_cover();
}

module fun_style() {
  union() {
    base_cover();
    fun_cosmic_monster();
  }
}

if (style == "fun") {
  fun_style();
} else {
  simple_style();
}
