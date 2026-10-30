/*
 BASE / iPhone 15 (standard, not Plus or Pro)
 Parametric concept CAD v0.1 — MUST verify dimensions and physical fit.
 Original aesthetic reference: Pamir AI Lapis One; BASE is independent.
 OpenSCAD: choose part and version then render with F6, export STL.
*/
$fn = 48;
part = "assembled"; // assembled | shell | wedge | insert | bezel | fit_coupon
version = "BASE01"; // BASE01 (decorative insert) | BASE02 (LCD pocket)

// Apple-published envelope dimensions. Camera/button values are estimates.
phone_w = 71.6;
phone_h = 147.6;
phone_d = 7.8;
fit = 0.50; // nominal clearance per side; calibrate per printer
wall = 2.00;
back_t = 1.80;
front_lip = 0.85;
inner_w = phone_w + 2*fit;
inner_h = phone_h + 2*fit;
outer_w = inner_w + 2*wall;
outer_h = inner_h + 2*wall;
body_z = back_t + phone_d + 0.5 + front_lip;

// Camera square is provisional. Validate by test fit before daily use.
cam_x = 19.1;
cam_y = 55.2;
cam_w = 36.0;
cam_h = 36.0;

// Rear Lapis-inspired module, oriented beneath camera clearance.
wedge_w = 65.0;
wedge_y0 = -5.0;
wedge_y1 = 36.0;
wedge_z0 = 0.0; // sits flush on case rear, avoids assembly interference
wedge_front = -5.0;
wedge_rear = -11.0;
win_y = 17;
win_w = 55.0;
win_h = 31.0;
tilt = -atan((abs(wedge_rear)-abs(wedge_front)) / (wedge_y1-wedge_y0));
win_z = wedge_front + (wedge_rear-wedge_front)*(win_y-wedge_y0)/(wedge_y1-wedge_y0);

module rr2(w,h,r) {
    offset(r=r) square([w-2*r,h-2*r], center=true);
}
module rr3(w,h,t,r) {
    linear_extrude(t) rr2(w,h,r);
}
module wedge_raw() {
    // Hull uses robust native solids (OpenSCAD preview supports their normals).
    hull() {
       translate([-wedge_w/2,wedge_y0,wedge_front])
           cube([wedge_w,0.15,wedge_z0-wedge_front]);
       translate([-wedge_w/2,wedge_y1-0.15,wedge_rear])
           cube([wedge_w,0.15,wedge_z0-wedge_rear]);
    }
}
module sloped_recess(w,h,depth) {
    translate([0,win_y,win_z]) rotate([tilt,0,0])
       translate([0,0,depth/2-0.12]) cube([w,h,depth],center=true);
}
module shell() {
    difference() {
        union() {
            // Open-front protective phone cavity.
            difference() {
                rr3(outer_w,outer_h,body_z,12.5);
                translate([0,0,back_t])
                    rr3(inner_w,inner_h,body_z+1,10.7);
            }
            // Decorative white lower-body raised step, following Lapis One's shape.
            translate([0,-38.8,-2.5]) rr3(65,66,2.5,7.8);
        }
        // Large rear-camera cutout. The actual bumper must be measured.
        translate([cam_x,cam_y,-3.1]) rr3(cam_w,cam_h,6.0,5.0);
        // Standard iPhone USB-C remains reachable at bottom edge.
        translate([0,-outer_h/2,6.2]) cube([15,8,12.8],center=true);
        // Microphone / speaker clearance below phone (initial approximation).
        for(x=[-24,24]) translate([x,-outer_h/2,6.2])
            cube([11,7,8.0],center=true);
        // Side button reliefs (approximate, designed to avoid pressing buttons).
        translate([outer_w/2,18,7.0]) cube([6,30,7.4],center=true);
        translate([-outer_w/2,17,7.0]) cube([6,36,7.4],center=true);
        translate([-outer_w/2,51,7.0]) cube([6,11,7.4],center=true);
        // Dedicated REAR USB-C opening in decorative lower-body panel.
        // THIS IS AN ACCESS SLOT, not a wired port. A matched extender is TBD.
        translate([0,-56.5,-1.3]) cube([15.0,8.0,8.0],center=true);
        // Small decorative round inset near lower right.
        translate([24,-51,-2.51]) cylinder(h=0.7,d=10);
    }
}
module wedge() {
    difference() {
        wedge_raw();
        if(version=="BASE01")
            sloped_recess(win_w,win_h,1.05);
        else
            // 55 x 31 pocket for 51.2 x 27.3 mm Waveshare LCD module;
            // verify its board thickness, connector, and full fit before use.
            sloped_recess(win_w,win_h,5.45);
    }
}
module insert() { // BASE01: flat, cosmetic black screen insert
    cube([54.2,30.2,0.8],center=true);
}
module bezel() { // BASE02: cover frame; install only after validating actual LCD
    difference() {
        cube([54.2,30.2,1.2],center=true);
        cube([43.4,23.4,2],center=true);
    }
}
module assembled() {
    color([0.93,0.93,0.90]) shell();
    color([1.0,0.47,0.035]) wedge();
    // Position screen insert on the inclined back face.
    color([0.07,0.08,0.09])
    translate([0,win_y,win_z-0.45]) rotate([tilt,0,0])
      if(version=="BASE01") insert(); else bezel();
}
module fit_coupon() { // 24mm section of case bottom: first fit/speaker test
    intersection() {
       shell();
       translate([0,-outer_h/2+12,4]) cube([outer_w+2,24,25],center=true);
    }
}
if(part=="assembled") assembled();
else if(part=="shell") shell();
else if(part=="wedge") wedge();
else if(part=="insert") insert();
else if(part=="bezel") bezel();
else if(part=="fit_coupon") fit_coupon();
