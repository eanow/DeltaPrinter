
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
cup_wall=1.2;

base_thick=6;

$fa=1;
$fs=1;

plate_w=40;
plate_l=80;

module base_shape()
{
    translate([0,0,base_thick/2])cube([20,90,base_thick],center=true);
    hull()
    {
        translate([0,2,base_thick/2])cube([20,50,base_thick],center=true);
        translate([0,shift,0])translate([0,0,base_thick/2])cube([56,25,base_thick],center=true);
    }
}
shift=12;
angle=30; //angle from vertical
extra_z=4;
module magnet_posts()
{
    //create pair, rotate into position

        for (bb=[-0.5:1:0.5])
        {
            translate([arm_gap*bb,shift,extra_z])rotate([angle,0,0])
            {
                translate([0,0,-extra_z*2])cylinder(r=mag_d/2+cup_wall,h=extra_z*2+mag_thick*2+cup_wall);
            }
        }
    
}
module magnet_space()
{
    //magnet
    //create pair, rotate into position

        for (bb=[-0.5:1:0.5])
        {
            translate([arm_gap*bb,shift,extra_z])rotate([angle,0,0])
            {
                translate([0,0,-extra_z*2-1])cylinder(r=mag_d/2,h=extra_z*2+mag_thick*2+1);
            }
        }

    //ball access
        for (bb=[-0.5:1:0.5])
        {
            translate([arm_gap*bb,shift,extra_z])rotate([angle,0,0])
            {
                translate([0,0,-extra_z*2-1])cylinder(r=mag_inner_d/2,h=2*(extra_z*2+mag_thick*2+1));
            }
        }
    
}

module mount_holes()
{
    roller_gap_h=66; //distance, center to center, of the two rollers ont he same side
    translate([0,(roller_gap_h/2-m3nut_r*2),base_thick/2])
    {
        cylinder(r=m3slot/2,h=base_thick*2,$fn=20,center=true);
    }
    translate([0,-(roller_gap_h/2-m3nut_r*2),base_thick/2])
    {
        cylinder(r=m3slot/2,h=base_thick*2,$fn=20,center=true);
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
        translate([0,0,-10])cube([160,160,20],center=true);//make it flat on bottom
    }
}
final();

//fit check
//rotate([90,0,0])translate([0,-(10+8+1),0])import("../stl/roller_carriage.stl");