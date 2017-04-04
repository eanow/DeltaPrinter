
plate_thick=3.5;
plate_l=123.4;
plate_w=79;
post_h=17.5;
cut_out_r=2.66;
board_lift=3; //minimum clearance for arduino thru hole pokies
$fa=.5;
$fs=.5;

fan_offset=0; //distance from edge of fan to floor
fan_r=75/2; //radius of 80mm fan portion
fan_hole_space=72;
module base_plate()
{
    translate([plate_l/2,-plate_w/2,plate_thick/2])cube([plate_l,plate_w,plate_thick],center=true);
    
    //fan
    translate([plate_l/2,-3.5,4.25])cube([plate_l,7,8.5],center=true);
    hull()
    {
        translate([plate_l/2,-2.5,4.25])cube([plate_l,5,8.5],center=true);
        translate([plate_l/2+4,-2.5,15])cube([plate_l-45,5,30],center=true);
    }
}
module screw_cut()
{
    //posts
    rr=2;
    translate([25.72,-25.1,-1])cylinder(r=rr,h=post_h+2);
    translate([100.6,-25.1,-1])cylinder(r=rr,h=post_h+2);
    translate([24.5,-73.2,-1])cylinder(r=rr,h=post_h+2);
    translate([106.9,-73.25,-1])cylinder(r=rr,h=post_h+2);
}
module mount_post()
{
    rr1=6;
    rr2=3.5;
    translate([25.72,-25.1,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    translate([100.6,-25.1,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    translate([24.5,-73.2,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    translate([106.9,-73.25,0])cylinder(r1=rr1,r2=rr2,h=post_h);
}
module fan()
{
    translate([65.6,0,54])rotate([90,0,0])cylinder(r=35,h=20,center=true);
    translate([65.6-35.7,0,54-35.6])rotate([90,0,0])cylinder(r=2.3,h=20,center=true);
    translate([65.6+35.8,0,54-35.6])rotate([90,0,0])cylinder(r=2.3,h=20,center=true);
    //hex
    translate([65.6-35.7,-4.5,54-35.6])rotate([90,0,0])rotate([0,0,30])cylinder(r=3.52,h=2,$fn=6,center=true);
    translate([65.6+35.8,-4.5,54-35.6])rotate([90,0,0])rotate([0,0,30])cylinder(r=3.52,h=2,$fn=6,center=true);
}
module tie_cut()
{
    translate([26,-18,0])cube([8,2,20],center=true);
    translate([101,-18,0])cube([8,2,20],center=true);
}
module final()
{
    difference()
    {
        union()
        {
            base_plate();
            mount_post();
            translate([25,-35,plate_thick-.05])scale([.8,1,1])spine();
            translate([25,-83,plate_thick-.05])scale([.8,1,1])spine();
            translate([75,-73.5,plate_thick-.05])rotate([0,0,93])scale([.5,1,1])spine();
        }
        screw_cut();
        fan();
        tie_cut();
    }
}
final();
module spine()
{
    difference()
    {
        cube([100,20,5]);
        translate([0,-13.5,2-.1])spine_cut();
        translate([0,13.5,2-.1])spine_cut(); 
    }
}
module spine_cut()
{
    minkowski()
    {
        cube([100,20,5]);
        sphere(r=2);
    }
}
//spine();