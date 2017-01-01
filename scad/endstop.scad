include<config.scad>;

switch_mount_hole_spacing=9.5;
switch_mount_hh=5;
module m5_hole()
{
    rotate([0,90,0])cylinder(r=m5_slot/2,h=inside_wall_thick*2,center=true);
    rotate([0,90,0])translate([0,0,inside_wall_thick+m5_wall-ep])cylinder(r=m5_head/2,h=inside_wall_thick*2,center=true);
}

//m5_hole();
xside=side+m5_wall;
yside=side+1+5+1.2;
round=3;
overhang=11.2;
module profile_a()
{
    difference()
    {
        translate([round,-(yside-side)/2,0])minkowski()
        {
            square([xside-round*2,yside-round*2],center=true);
            circle(r=round,$fn=30);
        }
        extrusion_side_profile();
    }
}
module profile_b()
{
    //extension
    
    difference()
    {
        translate([round-overhang/2,-(yside-side)/2,0])minkowski()
        {
            square([xside-round*2+overhang,yside-round*2],center=true);
            circle(r=round,$fn=30);
        }
        extrusion_side_profile();
        translate([-overhang-side/2,0])square([side+overhang,side+.8],center=true);
    }
}
module extrusion_side_profile()
{
    rotate([0,0,90])2020_cutout_two();
    translate([-side/2+slot/2+ep,side/2-slot/2-ep])square([side,side],center=true);
    
}
hh=20;
m2_slot=2.5;
m2_head=3.75+.5;
head_d=2.5;
module design_a()
{
difference()
{
    linear_extrude(hh)profile_a();
    translate([side/2,0,hh/2])m5_hole();
    //m2 mounting holes
    translate([switch_mount_hole_spacing/2,-yside/2,switch_mount_hh])rotate([90,0,0])cylinder(r=m2_slot/2,h=yside,center=true,$fn=30);
    translate([-switch_mount_hole_spacing/2,-yside/2,switch_mount_hh])rotate([90,0,0])cylinder(r=m2_slot/2,h=yside,center=true,$fn=30);
    //space for m2 head
    translate([switch_mount_hole_spacing/2,yside/2-side/2-head_d-.4,switch_mount_hh])rotate([90,0,0])cylinder(r=m2_head/2,h=yside,center=true,$fn=30);
    translate([-switch_mount_hole_spacing/2,yside/2-side/2-head_d-.4,switch_mount_hh])rotate([90,0,0])cylinder(r=m2_head/2,h=yside,center=true,$fn=30);
    
    
    //placed manually annulus
    translate([0+10+4,0-10-5,15])difference()
    {
        cylinder(r=4.5,h=4,center=true);
        cylinder(r=2.5,h=4.5,center=true);
    }
    //placed manually annulus
    translate([0,0-10-7,20])rotate([0,90,0])difference()
    {
        cylinder(r=4.5,h=4,center=true);
        cylinder(r=2.5,h=4.5,center=true);
    }
}
}

module design_b()
{
    difference()
    {
        linear_extrude(hh)profile_b();
        translate([side/2,0,hh/2])m5_hole();
        //m2 mounting holes
        translate([-overhang,0,0])
        {
        translate([switch_mount_hole_spacing/2,-yside/2,switch_mount_hh])rotate([90,0,0])cylinder(r=m2_slot/2,h=yside,center=true,$fn=30);
        translate([-switch_mount_hole_spacing/2,-yside/2,switch_mount_hh])rotate([90,0,0])cylinder(r=m2_slot/2,h=yside,center=true,$fn=30);
        //space for m2 head
        translate([switch_mount_hole_spacing/2,yside/2-side/2-head_d-.4,switch_mount_hh])rotate([90,0,0])cylinder(r=m2_head/2,h=yside,center=true,$fn=30);
        translate([-switch_mount_hole_spacing/2,yside/2-side/2-head_d-.4,switch_mount_hh])rotate([90,0,0])cylinder(r=m2_head/2,h=yside,center=true,$fn=30);
        }
        
        //placed manually annulus
        translate([0+10+4,0-10-5,15])difference()
        {
            cylinder(r=4.5,h=4,center=true);
            cylinder(r=2.5,h=4.5,center=true);
        }
        //placed manually annulus
        translate([0,0-10-7,20])rotate([0,90,0])difference()
        {
            cylinder(r=4.5,h=4,center=true);
            cylinder(r=2.5,h=4.5,center=true);
        }
    }
}
design_b();