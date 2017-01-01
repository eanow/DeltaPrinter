include <config.scad>;
module final()
{
    difference()
    {
        union()
        {
            linear_extrude(height=side)base_shape();
            align_bumps();
            tensioner_mount();
        }
        m5_holes();
        nut_slots();
    }
}

module m5_hole()
{
    rotate([0,90,0])cylinder(r=m5_slot/2,h=inside_wall_thick*2,center=true);
    rotate([0,90,0])translate([0,0,inside_wall_thick+m5_wall-ep])cylinder(r=m5_head/2,h=inside_wall_thick*2,center=true);
}
module m5_holes()
{
    //one for vertical
    translate([vertex_rad-vert_inset,0,side/2])m5_hole();
    bb=wing_length-side*.5;
    //two each for in plane
    rotate([0,0,60])translate([vertex_rad-side,side/2,side/2])rotate([0,0,180])m5_hole();
    rotate([0,0,-60])translate([vertex_rad-side,-side/2,side/2])rotate([0,0,180])m5_hole();
    rotate([0,0,60])translate([vertex_rad-side,bb,side/2])rotate([0,0,180])m5_hole();
    rotate([0,0,-60])translate([vertex_rad-side,-bb,side/2])rotate([0,0,180])m5_hole();
}
module align_bumps()
{
    yy=1*(channel_width)*(1/sin(60)); //hand tweaked
    rotate([0,0,60])translate([vertex_rad-side-ep,yy,side/2])bump();
    rotate([0,0,-60])translate([vertex_rad-side-ep,-yy,side/2])bump();
}
module bump()
{
    //fit inside tracks
    //trapezoidal shape- half a hexagon
    intersection()
    {
        rotate([0,90,90])cylinder(r=slot/2,h=10,$fn=6,center=true);
        translate([slot/2,0,0])cube([slot,20,slot*2],center=true);
    }
}
final();
//tensioner
//positioning the tensioner relative to the vertical frame
frame_vert_center=(vertex_rad-side/2-vert_inset);
//carriage
mount_t=6;
carriage_t=8;
carriage_off=1;
belt_w=6;
belt_plane=mount_t+carriage_t+carriage_off+belt_w/2+side/2+1.5; //adjusted to get more belt clearance
//translate([frame_vert_center-belt_plane,0,0])cylinder(r=1,h=20);
include <tensioner.scad>;
module tensioner_mount()
{
    linear_extrude(2)difference()
    {
        union()
        {
            //rounded vertex
            circle(r=vertex_rad,center=true);
            //'wings' along in plane extrusion lengths
            rotate([0,0,60])translate([-side+vertex_rad-inside_wall_thick*2,wing_length/2])square([inside_wall_thick*4,wing_length],center=true); 
            rotate([0,0,-60])translate([-side+vertex_rad-inside_wall_thick*2,-wing_length/2])square([inside_wall_thick*4,wing_length],center=true); 
        }
        //in plane extrusions
        rotate([0,0,60])translate([-side/2+vertex_rad,vertex_rad/2])square([side,vertex_rad],center=true);
        rotate([0,0,-60])translate([-side/2+vertex_rad,-vertex_rad/2])square([side,vertex_rad],center=true);
        //vertical extrusion
        translate([(-side/2)+vertex_rad-vert_inset,0,0])rotate([0,0,90])2020_cutout_two();
        //any remaining portion of hte circle we want removed
        open_inside();
        //tensioner holes
        translate([frame_vert_center-belt_plane,spacing,0])circle(r=m3_slot/2,center=true,$fn=40);
        translate([frame_vert_center-belt_plane,-spacing,0])circle(r=m3_slot/2,center=true,$fn=40);
    }
}


module nut_slots()
{
    rotate([0,0,-60])translate([-side/2+vertex_rad,0,side+ep])nut_fill();
    rotate([0,0,60])translate([vertex_rad+ep,0,side/2])rotate([0,90,0])nut_fill();
}