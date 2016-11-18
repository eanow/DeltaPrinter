//triangular vertex peices
$fa=1;
$fs=1;
ep=0.01;
//parametrics
//cutout for the AL extrusions, with 2 opposite tracks having an inset
//tweaked from ideal to satisfy printing limits
side=20;    //size of a side of the extrusion
slot=6;     //width of the slots, on the face
central=8;  //how wide the central pillar is; the slot depth is then (side-central)/2
//corner radius
vertex_rad=38;
//distance from edge to vertical 2020 shaft
vert_inset=5;
//thickness of the wall on the inside of the triangle
inside_wall_thick=5;
//belt channel width
channel_width=25;
//lenght of plastic alongside in-plane extrusion
wing_length=60;
//mounting hardware
m5_slot=6;
m5_head=11; //diameter of M5 head
m5_wall=4; //thickness of plastic between M5 and extrusion
module 2020_cutout_two()
{
    difference()
    {
        //main body
        square([side,side],center=true);
        //track slots
        translate([side/2+central/2,0])square([side,slot],center=true);
        translate([-(side/2+central/2),0])square([side,slot],center=true);
    }
}
module base_shape()
{
    difference()
    {
        union()
        {
            //rounded vertex
            circle(r=vertex_rad,center=true);
            //'wings' along in plane extrusion lengths
            rotate([0,0,60])translate([-side+vertex_rad-inside_wall_thick,wing_length/2])square([inside_wall_thick*2,wing_length],center=true); 
            rotate([0,0,-60])translate([-side+vertex_rad-inside_wall_thick,-wing_length/2])square([inside_wall_thick*2,wing_length],center=true); 
        }
        //in plane extrusions
        rotate([0,0,60])translate([-side/2+vertex_rad,vertex_rad/2])square([side,vertex_rad],center=true);
        rotate([0,0,-60])translate([-side/2+vertex_rad,-vertex_rad/2])square([side,vertex_rad],center=true);
        //vertical extrusion
        translate([(-side/2)+vertex_rad-vert_inset,0,0])rotate([0,0,90])2020_cutout_two();
        //opening for belts or motor
        motor_gap();
        //any remaining portion of hte circle we want removed
        open_inside();
    }
}
module motor_gap()
{
    //create rough triangle of unneeded area
    round=2;
    xx=-side-inside_wall_thick-round;
    qq=-(channel_width)/2+vertex_rad-vert_inset-side-inside_wall_thick;
    //make round
    minkowski()
    {
        intersection()
        {
            rotate([0,0,60])translate([xx,0])square([vertex_rad*2,vertex_rad*4],center=true);
            rotate([0,0,-60])translate([xx,0])square([vertex_rad*2,vertex_rad*4],center=true);
            translate([qq,0])square([channel_width-round*2,vertex_rad*2],center=true);
        }
        circle(r=round+0.01,$fn=40);
    }
}
module open_inside()
{
    //rest of interior
    //create rough triangle of unneeded area
    round=2;
    xx=-side-inside_wall_thick-round;
    qq=-side-inside_wall_thick-vert_inset-channel_width-inside_wall_thick;
    //make round
    minkowski()
    {
        intersection()
        {
            rotate([0,0,60])translate([xx,wing_length])square([vertex_rad*2,vertex_rad*4+wing_length],center=true);
            rotate([0,0,-60])translate([xx,-wing_length])square([vertex_rad*2,vertex_rad*4+wing_length],center=true);
            translate([qq,0])square([vertex_rad*2-round*2,vertex_rad*2+wing_length],center=true);
        }
        circle(r=round+0.01,$fn=40);
    }
}
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
    yy=.3*(channel_width)*(1/sin(60)); //hand tweaked
    bb=wing_length-side*.5;
    //two each for in plane
    rotate([0,0,60])translate([vertex_rad-side,yy,side/2])rotate([0,0,180])m5_hole();
    rotate([0,0,-60])translate([vertex_rad-side,-yy,side/2])rotate([0,0,180])m5_hole();
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