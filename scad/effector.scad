
ep=0.01;
//m3 hardware numbers that work
m3nut_r=6.6/2;
m3nut_t=3;
m3slot=3.5;
slot_d=m3nut_r*sqrt(3);

arm_gap=40; //center to center
mag_d=12.05+.7;
mag_thick=2.77+.4;
mag_inner_d=8.36+2;
magnet_clearance=2.5; //extra distance for magnets
cup_wall=1.2;

base_thick=6;

$fa=1;
$fs=1;

effector_d=60;
hole_d=30;

//effector is basically triangular, with a large hole in the center. 
//Actual hot end will be mounted to the effector using moutning holes.

module base_shape()
{
    //truncated circle
    //triangle has a side that is arm_gap plus some extra. We want to know
    //the distance to the base of that triangle.
    //can also do by hand.
    shift=26;
    linear_extrude(height=base_thick)difference()
    {
        circle(r=effector_d/2);
        for (a=[0:120:240])
        {
            rotate([0,0,a])translate([0,-(effector_d+shift)])square([effector_d*2,effector_d*2],center=true);
        }
    }
}
shift=24;
angle=30; //angle from vertical
extra_z=4.5+magnet_clearance;
module magnet_posts()
{
    //create pair, rotate into position
    for (aa=[0:120:240])
    {
        for (bb=[-0.5:1:0.5])
        {
            rotate([0,0,aa])translate([arm_gap*bb,-shift,extra_z])rotate([angle,0,0])
            {
                translate([0,0,-extra_z*2])cylinder(r=mag_d/2+cup_wall,h=extra_z*2+mag_thick*2+cup_wall);
            }
        }
    }
}
module magnet_space()
{
    //magnet
    //create pair, rotate into position
    for (aa=[0:120:240])
    {
        for (bb=[-0.5:1:0.5])
        {
            rotate([0,0,aa])translate([arm_gap*bb,-shift,extra_z])rotate([angle,0,0])
            {
                translate([0,0,-extra_z*2-1])cylinder(r=mag_d/2,h=extra_z*2+mag_thick*2+1);
            }
        }
    }
    //ball access
    for (aa=[0:120:240])
    {
        for (bb=[-0.5:1:0.5])
        {
            rotate([0,0,aa])translate([arm_gap*bb,-shift,extra_z])rotate([angle,0,0])
            {
                translate([0,0,-extra_z*2-1])cylinder(r=mag_inner_d/2,h=2*(extra_z*2+mag_thick*2+1));
            }
        }
    }
}
module mount_holes()
{
    //bit center hole
    cylinder(r=hole_d/2,h=base_thick*4,center=true);
    for (aa=[0:60:300])
    {
        rotate([0,0,aa])translate([0,hole_d/2+m3slot*1.5,0])cylinder(r=m3slot/2,h=base_thick*3,center=true,$fn=20);
    }
}
module final()
{
    difference()
    {
        union()
        {
            base_shape();   
            magnet_posts();
        }
        magnet_space();
        mount_holes();
        translate([0,0,-10])cube([effector_d*2,effector_d*2,20],center=true);//make it flat on bottom
    }
}
final();