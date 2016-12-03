
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
magnet_clearance=2.5; //extra distance to clear the belts
cup_wall=1.2;

base_thick=6;

$fa=1;
$fs=1;

plate_w=40;
plate_l=80;

pulley_r=12.2/2; //pulley radius, outside of teeth
idler_r=13/2+.8-1;
belt_slot();

module belt_slot()
{
    post_w=14;
    post_h=7;
    //at least 4 slots each side, plus gap of 6, so 8*2+6=22
    post_l=30-ep;
    gap=7+ep;
    belt_t=1;
    tooth_gap=2;
    teeth=floor(.5*post_l/tooth_gap)+1;
    translate([pulley_r,0,base_thick+post_h/2-ep])difference()
    {
        cube([post_w,post_l,post_h],center=true);    
        //gap for wraps
        //cube([post_w*2,gap,post_h*2],center=true);
        //belt 
        translate([0,-post_l/2,0])rotate([0,0,8])translate([0,post_l/2,0])
        translate([belt_t/2,0,0])cube([belt_t,post_l*2,post_h*2],center=true);
        translate([0,-post_l/2,0])rotate([0,0,8])translate([0,post_l/2,0])for (ii=[-teeth:1:teeth])
        {
            translate([-tooth_gap/4+ep,tooth_gap*ii,0])cube([tooth_gap/2,tooth_gap/2,post_h*2],center=true);
        }
        //belt
        translate([idler_r-pulley_r,0,0])
        { 
            translate([0,post_l/2,0])rotate([0,0,8])translate([0,-post_l/2,0])
            translate([belt_t/2,0,0])cube([belt_t,post_l*2,post_h*2],center=true);
            translate([0,post_l/2,0])rotate([0,0,8])translate([0,-post_l/2,0])for (ii=[-teeth:1:teeth])
            {
                translate([-tooth_gap/4+ep,tooth_gap*ii,0])cube([tooth_gap/2,tooth_gap/2,post_h*2],center=true);
            }
        }
    }
}

module base_shape()
{
    translate([0,0,base_thick/2])cube([20,85,base_thick],center=true);
    hull()
    {
        translate([0,2,base_thick/2])cube([20,55,base_thick],center=true);
        translate([0,shift,0])translate([0,0,base_thick/2])cube([56,25,base_thick],center=true);
    }
}
shift=12;
angle=30; //angle from vertical
extra_z=4.5+magnet_clearance;
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
            translate([0,0,magnet_clearance])magnet_posts();
        }
        translate([0,0,magnet_clearance])magnet_space();
        translate([0,0,magnet_clearance])mount_holes();
        translate([0,0,-10])cube([160,160,20],center=true);//make it flat on bottom
    }
}
final();

//fit check
//rotate([90,0,0])translate([0,-(10+8+1),0])import("../stl/roller_carriage.stl");