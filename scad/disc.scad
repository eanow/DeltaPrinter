disc_r=25;
disc_h=10;
$fs=1;
$fa=.5;
nut_l=11;
include <config.scad>;
difference()
{
    union()
    {
        cylinder(r1=disc_r+3,r2=disc_r-3,h=disc_h);
        rotate([90,0,0])cylinder(r=slot/2,h=disc_r*2,$fn=6,center=true);
    }
    translate([0,0,0])rotate([0,0,0])cylinder(r=m5_slot/2,h=50,$fn=20,center=true);
    translate([0,0,25+inside_wall_thick])rotate([0,0,0])cylinder(r=m5_head/2,h=50,$fn=20,center=true);
    translate([0,0,-5])cube([disc_r*4,nut_l,10],center=true);
    translate([2*disc_r+side/2,0,0])cube([disc_r*4,disc_r*4,disc_h*4],center=true);
}