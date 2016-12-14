include <config.scad>;
module final()
{
    difference()
    {
        union()
        {
            linear_extrude(height=side)base_shape();
            align_bumps();
        }
        m5_holes();
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
//m5_holes();
//motor_gap();
//triangle
//circle(r=30,center=true,$fn=3);