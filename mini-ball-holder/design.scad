
$fn = 5;

difference() {
  union() {
    difference() {
      union() {
        cylinder(h = 30, r1 = 45, r2 = 32, center = true);
      }
      translate([0,0,24.835]) {
        sphere(r = 21.835);
      }
    }
  }
  translate([0,0,-15]) {
    linear_extrude(
      height = 0.6,
      twist = 0,
      slices = 1,
      scale = 1,
      center = false
    ) {
      mirror([1,0,0]) {
        translate([0,0,0])
        text("Designed by Kushal", size=2, font="Arial", halign="center", valign="center", spacing=1.3);
      }
    }
  }
}
