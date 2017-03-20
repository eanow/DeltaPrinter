pcb_d=215;
screw_inset=5.0;
base_ext_l=331;

include <config.scad>;
m3nut_r=6.6/2;
virt_r=((base_ext_l)/2)/(sqrt(3));
//center to inside frame edge
center_to_edge=(virt_r+(vertex_rad-side));
echo(center_to_edge);
//frame edge to the center of the support screw
edge_to_screw=center_to_edge-(pcb_d/2)+screw_inset;
echo(edge_to_screw);

mount_gap=piece_h-side; //half a side in from top and bottom

round=2;

difference()
{
    bracket();
    mount_holes();
    mount_clearance();
}

module mount_holes()
{
    //m5 bolts
    for (bb=[-.5:1:.5])
    {
        translate([bb*mount_gap,0,0])
        {
            for (aa=[-.5:1:.5])
            {
                translate([0,0,mount_gap*aa])rotate([90,0,0])cylinder(r=m5_slot/2,h=50,$fn=20,center=true);
            }
            translate([0,25+inside_wall_thick,mount_gap*-.5])rotate([90,0,0])cylinder(r=m5_head/2,h=50,$fn=20,center=true);
        }
    }
    //m3 screw
    translate([0,edge_to_screw,0])cylinder(r=m3_slot/2,h=50,$fn=12,center=true);
    //hex trap
    translate([0,edge_to_screw,-25])rotate([0,0,30])cylinder(r=m3nut_r,h=50,$fn=6,center=true);
}

module mount_clearance()
{
    translate([0,mount_gap+inside_wall_thick,piece_h/2+inside_wall_thick/2])cube([side*2,mount_gap*2,piece_h],center=true);
}

module bracket()
{
    y_l=edge_to_screw+inside_wall_thick+m3_slot/2;
    hull()
    {
        translate([0,inside_wall_thick,0])rotate([90,0,0])linear_extrude(height=inside_wall_thick)minkowski()
        {
            square([side-2-round*2,(piece_h-6)-round*2],center=true);
            //cube([side,inside_wall_thick,piece_h-5],center=true);
            circle(r=round,$fn=20);
        }
        translate([0,y_l/2,-inside_wall_thick/2])linear_extrude(inside_wall_thick)minkowski()
        {
            square([side-2-round*2,y_l-round*2],center=true);
            //cube([side,y_l,inside_wall_thick],center=true);
            circle(r=round,$fn=20);
        }
    }
    //bevelize
    hull()
    {
        translate([0,0,0])rotate([-90,0,0])linear_extrude(height=ep)minkowski()
        {
            square([mount_gap-5+side-round*2,(piece_h-5)-round*2],center=true);
            //cube([side,inside_wall_thick,piece_h-5],center=true);
            circle(r=round-.5,$fn=20);
        }
        translate([0,1,0])rotate([-90,0,0])linear_extrude(height=ep)minkowski()
        {
            square([mount_gap-5+side-round*2,(piece_h-5)-round*2],center=true);
            //cube([side,inside_wall_thick,piece_h-5],center=true);
            circle(r=round,$fn=20);
        }
        translate([0,inside_wall_thick-1-ep,0])rotate([-90,0,0])linear_extrude(height=ep)minkowski()
        {
            square([mount_gap-5+side-round*2,(piece_h-5)-round*2],center=true);
            //cube([side,inside_wall_thick,piece_h-5],center=true);
            circle(r=round,$fn=20);
        }
        translate([0,inside_wall_thick-ep,0])rotate([-90,0,0])linear_extrude(height=ep)minkowski()
        {
            square([mount_gap-5+side-round*2,(piece_h-5)-round*2],center=true);
            //cube([side,inside_wall_thick,piece_h-5],center=true);
            circle(r=round-.5,$fn=20);
        }
    }
}