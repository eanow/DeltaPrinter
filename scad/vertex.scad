//triangular vertex peices
$fa=1;
$fs=1;
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
        circle(r=vertex_rad,center=true);
        rotate([0,0,60])translate([-side/2+vertex_rad,vertex_rad/2])square([side,vertex_rad],center=true);
        rotate([0,0,-60])translate([-side/2+vertex_rad,-vertex_rad/2])square([side,vertex_rad],center=true);
        translate([(-side/2)+vertex_rad-vert_inset,0,0])rotate([0,0,90])2020_cutout_two();
        motor_gap();
    }
}
module motor_gap()
{
    //create rough triangle of unneeded area
    xx=-side-inside_wall_thick-2;
    //make round
    minkowski()
    {
        intersection()
        {
            rotate([0,0,60])translate([xx,0])square([vertex_rad*2,vertex_rad*4],center=true);
            rotate([0,0,-60])translate([xx,0])square([vertex_rad*2,vertex_rad*4],center=true);
            #translate([-(vert_inset)+xx,0])square([vertex_rad*2,vertex_rad*2],center=true);
        }
        circle(r=2,$fn=40);
    }
}
base_shape();
//motor_gap();
//triangle
//circle(r=30,center=true,$fn=3);