module hotend()
{
    translate([0,0,-8])rotate([90,0,0])import("../stl/e3dmockup.stl");
}

//hotend();
ep=0.01;
//m3 hardware numbers that work
m3nut_r=6.6/2;
m3nut_t=3;
m3slot=3.5;
slot_d=m3nut_r*sqrt(3);

arm_gap=40; //center to center

base_thick=12;

$fa=1;
$fs=1;

effector_d=60;
hole_d=30;

ball_d=9.5+.6;
socket_lift=6;

//effector is basically triangular, with a large hole in the center. 
//Actual hot end will be mounted to the effector using moutning holes.

module base_shape()
{
    cylinder(r1=effector_d*.75,r2=effector_d*.60,h=base_thick);
    translate([0,0,ep])mirror([0,0,-1])cylinder(r1=effector_d*.75,r2=effector_d*.75-.5,h=.5);
}

module ball_sockets()
{
    //two spheres for the balls, around three sides, and a slant, and the string hole
    translate([0,0,socket_lift])for (aa=[0:120:240])
    {
        rotate([0,0,aa]) 
        {
            for (bb=[-.5:1:.5])
            {
                //balls
                translate([effector_d/2,bb*arm_gap,0])sphere(r=ball_d/2,$fn=150);
            }
            //slant
            translate([effector_d/2,0,0])rotate([0,-45,0])translate([25,0,0])cube([50,effector_d*2,100],center=true);
            //bevelslant
            translate([effector_d/2,0,-socket_lift])rotate([0,45,0])translate([29.25,0,0])cube([50,effector_d*2,100],center=true);
            //string
            translate([effector_d/2,0,0])rotate([0,45,0])cylinder(r=1.2,h=base_thick*4,center=true);
            translate([effector_d/2*.65,0,0])cylinder(r=m3slot/2,h=base_thick*4,center=true);
            translate([effector_d/2*.65,0,-socket_lift+base_thick-m3nut_t+ep])cylinder(r=m3nut_r,h=m3nut_t,$fn=6);
        }
    }
}

module mount_holes()
{
    cylinder(r=hole_d/2,h=base_thick*4,center=true);
    for (aa=[60:120:300])
    {
        rotate([0,0,aa]) 
        {
            translate([hole_d/2+8,0,0])cylinder(r=m3slot/2,h=base_thick*4,center=true);
            translate([hole_d/2+8,0,-ep-.5])cylinder(r=m3nut_r,h=m3nut_t+.5,$fn=6);
        }
    }
}
module final()
{
    difference()
    {
        union()
        {
            base_shape();   
        }
        mount_holes();
        ball_sockets();
        //translate([0,0,-10])cube([effector_d*2,effector_d*2,20],center=true);//make it flat on bottom
    }
}
final();/*
difference()
{
translate([effector_d/2,arm_gap/2,6])cube([20,20,12],center=true);
ball_sockets();
}*/