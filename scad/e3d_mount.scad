module hotend()
{
    translate([0,0,-8.7])rotate([90,0,0])import("../stl/e3dmockup.stl");
}
$fs=1;
$fa=1;
ep=0.001;
//hotend();
module effector()
{
    import("../stl/effector_tension.stl");
}
//effector();
hole_d=30;
mount_r=7;
base_thick=12;
mount_h=3;
m3nut_r=6.6/2;
m3nut_t=3;
m3slot=3.5;
m3_head_r=6.1/2;

m2nut_r=5/2;
m2slot=2.5;
m2head_r=5/2;

neck_outer_r=16/2;
neck_inner_r=12/2;
neck_inner_h=6;
neck_lower_h=3;
neck_upper_h=3.7;

zip_head=5;
zip_body=3;
zip_thick=4;

//three mount points
module top_plate_shape()
{
    difference()
    {
        hull()
        {
            for (aa=[60:120:300])
            {
                rotate([0,0,aa])translate([hole_d/2+8,0])circle(r=mount_r);
            }
        }
        for (aa=[0:120:300])
        {
            rotate([0,0,aa])translate([hole_d/2+6,0])circle(r=5);//rotate([0,0,45])square([10,10],center=true);
        }
    }
}

module neck_holder()
{
    translate([0,0,ep])cylinder(r=hole_d/2-1, h=base_thick+mount_h);
}

module e3d_channel()
{
    r_diff=neck_outer_r-neck_inner_r;
    cylinder(r=neck_outer_r,h=neck_lower_h+ep);
    translate([0,0,neck_lower_h])cylinder(r=neck_inner_r,h=neck_inner_h+ep);
    translate([0,0,neck_lower_h+neck_inner_h-r_diff])cylinder(r1=neck_inner_r,r2=neck_outer_r,h=r_diff+ep);
    translate([0,0,neck_lower_h+neck_inner_h])cylinder(r=neck_outer_r,h=neck_upper_h+ep);
    translate([0,0,neck_lower_h+neck_inner_h+neck_upper_h])cylinder(r=neck_inner_r,h=mount_h*2+ep);
}
module vert_screws()
{
    for (aa=[60:120:300])
    {
        rotate([0,0,aa])translate([hole_d/2+8,0])cylinder(r=m3slot/2,h=base_thick+mount_h*2);
    }
}
module hort_screws()
{
    for (bb=[-1:2:1])
    {
        translate([0,bb*9.5,5.8])rotate([0,-90,0])
        {   
            translate([0,0,-4])cylinder(r=m2slot/2,h=hole_d);
            translate([0,0,-hole_d-4+ep])cylinder(r=m2head_r,h=hole_d);
            translate([0,0,4])cylinder(r=m2nut_r,h=hole_d,$fn=6);
        }
    }
    /*
    //zip tie ring
    translate([0,0,2])difference()
    {
        %cylinder(r=hole_d/2,h=zip_body,center=true);
        %cylinder(r=hole_d/2-zip_thick,h=zip_body+1,center=true);
    }
    //zip tie ring
    translate([0,0,7.5])difference()
    {
        %cylinder(r=hole_d/2,h=zip_body);
    }*/
}

module final()
{
    difference()
    {
        union()
        {
            translate([0,0,base_thick])linear_extrude(height=mount_h)top_plate_shape();
            neck_holder();
        }
        e3d_channel();
        vert_screws();
        hort_screws();
    }
}
//cut in half
intersection()
{
    union()
    {
        translate([50,0,-1])cube([100,100,50],center=true);
        translate([0,11,0])rotate([0,0,45])cube([3,3,50],center=true);
        translate([0,-11,0])rotate([0,0,45])cube([3,3,50],center=true);
    }
    final();
}
//cut in half
translate([-10,0,0])difference()
{
    final();
    union()
    {
        translate([50,0,-1])cube([100,100,50],center=true);
        translate([0,11,0])rotate([0,0,45])cube([3,3,50],center=true);
        translate([0,-11,0])rotate([0,0,45])cube([3,3,50],center=true);
    }
}