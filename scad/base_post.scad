include <config.scad>;
include <base_config.scad>;

module post_corner()
{
    difference()
    {
        union()
        {
            //rounded vertex
            circle(r=vertex_rad);          
        }
        //in plane extrusions
        rotate([0,0,60])translate([-grid_wall_thick/2+vertex_rad,vertex_rad/2])square([grid_wall_thick,vertex_rad],center=true);
        rotate([0,0,-60])translate([-grid_wall_thick/2+vertex_rad,-vertex_rad/2])square([grid_wall_thick,vertex_rad],center=true);
        post_gap();
        //round the ends
        difference()
        {
            rotate([0,0,60])translate([-grid_wall_thick-inside_wall_thick/2+vertex_rad,vertex_rad/2])translate([0,10+inside_wall_thick/2])square([inside_wall_thick+.1,20+inside_wall_thick+.1],center=true);
            rotate([0,0,60])translate([-grid_wall_thick-inside_wall_thick/2+vertex_rad,vertex_rad/2])circle(r=inside_wall_thick/2+.1);
        }
        difference()
        {
            rotate([0,0,-60])translate([-grid_wall_thick-inside_wall_thick/2+vertex_rad,-vertex_rad/2])translate([0,-(10+inside_wall_thick/2)])square([inside_wall_thick+.1,20+inside_wall_thick+.1],center=true);
            rotate([0,0,-60])translate([-grid_wall_thick-inside_wall_thick/2+vertex_rad,-vertex_rad/2])circle(r=inside_wall_thick/2+.1);
        }
    }
}


module post_gap()
{
    //create rough triangle of unneeded area
    round=2;
    xx=-grid_wall_thick-inside_wall_thick-round;
    qq=-(vertex_rad*2)/2+vertex_rad-vert_inset-side-inside_wall_thick;
    //make round
    minkowski()
    {
        intersection()
        {
            rotate([0,0,60])translate([xx,0])square([vertex_rad*2,vertex_rad*4],center=true);
            rotate([0,0,-60])translate([xx,0])square([vertex_rad*2,vertex_rad*4],center=true);
            translate([qq,0])square([vertex_rad*2-round*2,vertex_rad*2],center=true);
        }
        circle(r=round+0.01,$fn=40);
    }
}
module m3hole()
{
    rotate([0,90,0])
    {
        cylinder(r=m3_slot/2,h=20,$fn=16);
        cylinder(r=m3nut_r,h=m3nut_t,$fn=6);
    }
}
difference()
{

linear_extrude(height=atx_height+vertical_buffer)post_corner();
    //m3 mounting holes
rotate([0,0,-60])translate([vertex_rad-inside_wall_thick-grid_wall_thick,-wall_screw_horz,0])
    {   
        translate([0,0,wall_screw_vert])m3hole();
        translate([0,0,atx_height+vertical_buffer-wall_screw_vert])m3hole();
    }
rotate([0,0,60])translate([vertex_rad-inside_wall_thick-grid_wall_thick,wall_screw_horz,0])
    {   
        translate([0,0,wall_screw_vert])m3hole();
        translate([0,0,atx_height+vertical_buffer-wall_screw_vert])m3hole();
    }
    //anti-vibration foot
    translate([vertex_rad-foot_d/2-2.4,0,atx_height+vertical_buffer])cylinder(d=foot_d,h=8,center=true);
}

//%translate([0,0,2])base_shape();