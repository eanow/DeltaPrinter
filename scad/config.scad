//triangular vertex peices
$fa=1;
$fs=1;
ep=0.01;
//parametrics
//cutout for the AL extrusions, with 2 opposite tracks having an inset
//tweaked from ideal to satisfy printing limits
side=20;    //size of a side of the extrusion
slot=6-.4;     //width of the slots, on the face
central=8+1;  //how wide the central pillar is; the slot depth is then (side-central)/2
//corner radius
vertex_rad=40;
//distance from edge to vertical 2020 shaft
vert_inset=6;
//thickness of the wall on the inside of the triangle
inside_wall_thick=6;
//belt channel width
channel_width=26;
//lenght of plastic alongside in-plane extrusion
wing_length=70;
//height of the frame piece
piece_h=50;
//mounting hardware
m5_slot=6;
m5_head=10; //diameter of M5 head
m5_wall=5; //thickness of plastic between M5 and extrusion
//m3 sizing
m3_slot=3.5;
m3nut_r=6.6/2;
m3nut_t=3;
module 2020_cutout_two()
{
    ss=side+.8; //printer tolerance
    difference()
    {
        //main body
        square([ss,ss],center=true);
        //track slots
        translate([ss/2+central/2,0])square([ss,slot],center=true);
        translate([-(ss/2+central/2),0])square([ss,slot],center=true);
        translate([0,(ss/2+central/2)])square([slot,ss],center=true);
    }
}
module nut_fill()
{
    nut_w=10.5+1;
    nut_w_b=6.5+1.5;
    nut_depth=(side-central)/2;
    //spaces for inserting the t slot nuts
    //translate([0,0,-nut_depth/2])
    hull()
    {
        cube([nut_w+3,nut_w*2,ep],center=true);
        translate([0,0,-nut_depth])cube([nut_w_b,nut_w*2,ep],center=true);
    }
    //cube([nut_w,nut_w*2,nut_depth],center=true);
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
            rotate([0,0,60])translate([-side+vertex_rad-inside_wall_thick*2,wing_length/2])square([inside_wall_thick*4,wing_length],center=true); 
            rotate([0,0,-60])translate([-side+vertex_rad-inside_wall_thick*2,-wing_length/2])square([inside_wall_thick*4,wing_length],center=true); 
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
