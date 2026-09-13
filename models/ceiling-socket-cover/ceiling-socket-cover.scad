// Ceiling socket hole cover (medallion style)
// Reusable parametric design with three options:
// 1) Simple clean cover
// 2) Fun cosmic-monster cover
// 3) Kraken abyss cover (chaotic)
//
// Usage:
// - Set style = "simple", "fun", or "kraken"
// - Tune hole_diameter to your measured ceiling hole
// - Set mount_mode to press_fit / screw_tabs / locator_ring
// - Export STL from OpenSCAD

$fn = 160;

// ----- Core fit params -----
style = "simple";          // "simple", "fun", or "kraken"
hole_diameter = 68;         // measured hole in ceiling (mm)
clearance = 2.0;            // extra coverage beyond hole radius (mm)
cover_thickness = 2.4;      // top plate thickness (mm)
edge_rounding = 0.6;        // small rim rounding visual (mm)

// ----- Optional center pass-through -----
center_wire_hole = false;   // full concealment default (set true only if you need pass-through)
wire_hole_diameter = 12;    // mm

// ----- Mounting (required for real install) -----
// "press_fit" (default): rear tabs flex into the hole
// "screw_tabs": side ears with screw holes
// "locator_ring": passive centering ring only
// "none": visual-only part (not recommended for install)
mount_mode = "press_fit";      // "press_fit", "screw_tabs", "locator_ring", "none"

rear_locator_ring = true;       // shared with press-fit + locator_ring
locator_diameter = hole_diameter - 0.6;
locator_depth = 2.0;
locator_wall = 1.2;

press_fit_tab_count = 4;
press_fit_tab_width = 8.0;
press_fit_tab_depth = 1.4;      // radial protrusion from locator ring
press_fit_tab_height = 1.8;     // Z depth under cover

screw_tab_span = cover_diameter + 18;   // center-to-center between ears
screw_tab_diameter = 12;
screw_hole_diameter = 4.2;
screw_tab_thickness = 2.6;

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

module mount_locator_ring() {
  if (rear_locator_ring || mount_mode == "press_fit" || mount_mode == "locator_ring") {
    translate([0,0,-locator_depth])
    difference() {
      cylinder(d = locator_diameter, h = locator_depth);
      cylinder(d = max(0.1, locator_diameter - 2*locator_wall), h = locator_depth + 0.1);
    }
  }
}

module mount_press_fit_tabs() {
  if (mount_mode == "press_fit") {
    tab_r = locator_diameter/2 + press_fit_tab_depth*0.55;
    for (a = [0 : 360/press_fit_tab_count : 360 - 360/press_fit_tab_count]) {
      rotate([0,0,a])
      translate([tab_r,0,-press_fit_tab_height])
      hull() {
        cube([press_fit_tab_depth, press_fit_tab_width, press_fit_tab_height], center=true);
        translate([press_fit_tab_depth*0.45,0,press_fit_tab_height*0.30])
          cube([press_fit_tab_depth*0.6, press_fit_tab_width*0.76, press_fit_tab_height*0.38], center=true);
      }
    }
  }
}

module mount_screw_tabs() {
  if (mount_mode == "screw_tabs") {
    cover_r = cover_diameter/2;
    for (sx=[-1,1]) {
      ear_x = sx * screw_tab_span/2;

      // connected ear
      translate([ear_x, 0, 0])
      difference() {
        cylinder(d = screw_tab_diameter, h = screw_tab_thickness);
        translate([0,0,-0.1]) cylinder(d = screw_hole_diameter, h = screw_tab_thickness + 0.2);
      }

      // bridge from cover rim to ear so it's truly attached
      hull() {
        translate([sx*(cover_r - 1.0),0,0]) cylinder(d=6.0, h=screw_tab_thickness);
        translate([ear_x - sx*(screw_tab_diameter*0.25),0,0]) cylinder(d=6.5, h=screw_tab_thickness);
      }
    }
  }
}

module base_cover() {
  difference() {
    union() {
      rounded_disc(cover_diameter, cover_thickness, edge_rounding);
      mount_locator_ring();
      mount_press_fit_tabs();
      mount_screw_tabs();
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

module kraken_abyss() {
  face_d = cover_diameter * 0.72;
  z0 = cover_thickness - 0.02;
  eye_d = face_d * 0.16;

  union() {
    // broken abyss ring
    difference() {
      translate([0,0,z0]) cylinder(d = face_d*0.95, h = fun_relief_height);
      translate([0,0,z0-0.05]) cylinder(d = face_d*0.74, h = fun_relief_height + 0.1);
      rotate([0,0,18]) translate([ face_d*0.42,0,z0-0.1]) cube([face_d*0.32, face_d*0.22, fun_relief_height+0.3], center=true);
      rotate([0,0,196]) translate([ face_d*0.40,0,z0-0.1]) cube([face_d*0.28, face_d*0.18, fun_relief_height+0.3], center=true);
    }

    // eyes
    translate([-face_d*0.13, face_d*0.08, z0]) cylinder(d = eye_d, h = fun_relief_height);
    translate([ face_d*0.13, face_d*0.08, z0]) cylinder(d = eye_d, h = fun_relief_height);

    // pupil slits
    translate([-face_d*0.13, face_d*0.08, z0 + fun_relief_height*0.12]) cube([eye_d*0.20, eye_d*0.92, fun_relief_height*0.82], center=true);
    translate([ face_d*0.13, face_d*0.08, z0 + fun_relief_height*0.12]) cube([eye_d*0.20, eye_d*0.92, fun_relief_height*0.82], center=true);

    // crown horns
    for (sx=[-1,1]) {
      translate([sx*face_d*0.17, face_d*0.28, z0])
      linear_extrude(height = fun_relief_height)
      polygon(points=[[0,0],[sx*face_d*0.08,face_d*0.06],[sx*face_d*0.03,face_d*0.14]]);
    }

    // asymmetric tentacle forest
    t1 = [for (i=[0:8]) [ face_d*(0.03+i*0.06), -face_d*(0.03+i*0.03) + face_d*0.05*sin(i*38) ]];
    t2 = [for (i=[0:7]) [-face_d*(0.02+i*0.055), -face_d*(0.02+i*0.028) + face_d*0.06*sin(i*46+25) ]];
    curve_strip(t1, face_d*0.088, fun_relief_height, z0);
    curve_strip(t2, face_d*0.082, fun_relief_height, z0);

    // central maw
    translate([0, -face_d*0.08, z0])
    difference() {
      cylinder(d = face_d*0.24, h = fun_relief_height);
      translate([0,0,-0.05]) cylinder(d = face_d*0.14, h = fun_relief_height + 0.1);
    }
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

module kraken_style() {
  union() {
    base_cover();
    kraken_abyss();
  }
}

if (style == "fun") {
  fun_style();
} else if (style == "kraken") {
  kraken_style();
} else {
  simple_style();
}
