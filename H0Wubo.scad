
/* [Led] */

// Diameter (mm)
led_diameter              =  3.0;  // [2.0 : 0.05 : 5.0]

// Height (mm)
led_height                =  3.6;  // [1.0 : 0.05 : 5.0]

// Rim thickness (mm)
led_rim_thickness         =  0.25; // [0.0 : 0.05 : 1.0]

// Rim height (mm)
led_rim_height            =  1.0;  // [0.0 : 0.05 : 2.0]

/* [Back board] */

// Distance between lamps (mm)
lamp_distance             =  8.0;  // [3.0 : 0.1 : 10.0]

// Thickness of the board (mm)
board_thickness           =  1.3;  // [0.5 : 0.1 : 3.0]

/* [Shadow cap] */

// Wall thickness (nozzle)
shadow_cap_wall_thickness =  1;    // [1 : 0.5 : 3]

// Length (mm)
shadow_cap_length         =  3.5;  // [1.0 : 0.1 : 5.0]

// Overhang (mm)
shadow_cap_overhang       =  2.0;  // [1.0 : 0.1 : 5.0]

/* [Hidden] */

VEC_X = [1, 0, 0];
VEC_Y = [0, 1, 0];
VEC_Z = [0, 0, 1];

Wubo();

module Wubo(
    lamp_distance             = mm(lamp_distance),
    board_thickness           = mm(board_thickness),
    shadow_cap_wall_thickness = nozzle(shadow_cap_wall_thickness),
    shadow_cap_length         = mm(shadow_cap_length),
    shadow_cap_overhang       = mm(shadow_cap_overhang),
    led_diameter              = mm(led_diameter),
    led_height                = mm(led_height),
    led_rim_thickness         = mm(led_rim_thickness),
    led_rim_height            = mm(led_rim_height),
    $fn                       = 64
) {
    led_rim_diameter = led_diameter + 2 * led_rim_thickness;
    
    difference() {
        union() {
            BackPlate();
            lamp_postion() ShadowCap();
        }
        lamp_postion() LedHole();
    }
    if($preview) color("LightYellow", 0.5)lamp_postion() Led();
    
    module BackPlate() {
        difference() {
            linear_extrude(board_thickness) {
                hull() {
                    lamp_postion() {
                        circle(d = lamp_distance);
                    }
                    translate([0, -lamp_distance / 4]) {
                        square(
                            [lamp_distance, lamp_distance / 2],
                            true
                        );
                    }
                }
            }
        }
    }
    
    module ShadowCap() {
        d = led_diameter + 2 * shadow_cap_wall_thickness;
        h = board_thickness + shadow_cap_length;
        intersection() {
            cylinder(
                d = d,
                h = h
            );
            rotate(-90)rotate(90, VEC_X) {
                linear_extrude(d, center = true, convexity = 3) {
                    translate([-d/2, h - d / 2]) circle(d= d );
                    mirror(VEC_X) square([d / 2, h - d / 2]);
                    square([d / 2, h - shadow_cap_overhang]);
                }
            }
        }
    }
    
    module LedHole() {
        BIAS = 0.1;
        cylinder(
            d = led_rim_diameter,
            h = 2 * (board_thickness - layer(1)),
            center = true
        );
        
        cylinder(
            d = led_diameter,
            h = board_thickness + shadow_cap_length + BIAS
        );
    }
    
    module Led() {
        h = led_rim_height + led_height - led_diameter / 2;
        cylinder(d = led_diameter, h = h);
        translate([0,0,h]) sphere(d = led_diameter);
            
        cylinder(d = led_rim_diameter, h = led_rim_height);
    }
    
    module lamp_postion() {
        copy_mirror(VEC_X) {
            translate([lamp_distance / 2, 0]) {
                children();
            }
        }
    }
}
function mm(x)     = x;
function nozzle(x) = x * mm(0.4);
function layer(x)  = x * mm(0.15);
function degree(x) = x;

function map(x, in_min, in_max, out_min, out_max) = (
    (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
);

module copy_mirror(vec) {
    children();
    mirror(vec) children();
}
