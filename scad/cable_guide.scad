
include <config.scad>;
m3nut_r=6.6/2;


mount_gap=piece_h-side; //half a side in from top and bottom

round=2;
support_depth=40;



module beveler()
{
    $fa=.5;
    $fs=.5;
    translate([round,0,0])hull()
    {
        translate([0,0,-m5_head])linear_extrude(height=ep)minkowski()
        {
            frame_cross();
            circle(r=round-1);
        }
        translate([0,0,-m5_head+1])linear_extrude(height=ep)minkowski()
        {
            frame_cross();
            circle(r=round);
        }
        translate([0,0,m5_head-1-ep])linear_extrude(height=ep)minkowski()
        {
            frame_cross();
            circle(r=round);
        }
        translate([0,0,m5_head-ep])linear_extrude(height=ep)minkowski()
        {
            frame_cross();
            circle(r=round-1);
        }
    }
}
difference()
{
    beveler();
    rotate([0,0,-8])translate([-2,2,0])
    {
        opener_a();
        opener_b();
        opener_c();
        translate([0,198,0])mirror([0,1,0])opener_c();
        translate([0,198,0])mirror([0,1,0])opener_b();
    }
    mount_holes();
}

module frame_cross()
{
    translate([0,-piece_h/2+2+round,0])hull()
    {
        translate([(support_depth-round*2)/2+20,180,0])square([support_depth-round*2,ep],center=true);
        translate([(support_depth-round*2)/2,40,0])square([support_depth-round*2,ep],center=true);
        translate([(inside_wall_thick-round*2)/2,0,0])square([inside_wall_thick-round*2,ep],center=true);
    }
}
module opener_a()
{
    $fa=.5;
    $fs=.5;
    translate([round,0,0])hull()
    {
        translate([0,0,-m5_head-ep])linear_extrude(height=ep*2)minkowski()
        {
            frame_open_a();
            circle(r=round+1);
        }
        translate([0,0,-m5_head+1])linear_extrude(height=ep)minkowski()
        {
            frame_open_a();
            circle(r=round);
        }
    }
    translate([round,0,0])hull()
    {
        translate([0,0,-m5_head+1])linear_extrude(height=ep)minkowski()
        {
            frame_open_a();
            circle(r=round);
        }
        translate([0,0,m5_head-1-ep])linear_extrude(height=ep*2)minkowski()
        {
            frame_open_a();
            circle(r=round);
        }
    }
    translate([round,0,0])hull()
    {
        translate([0,0,m5_head-1-ep])linear_extrude(height=ep)minkowski()
        {
            frame_open_a();
            circle(r=round);
        }
        translate([0,0,m5_head-ep])linear_extrude(height=ep*2)minkowski()
        {
            frame_open_a();
            circle(r=round+1);
        }
    }
}
module frame_open_a()
{
    gap=inside_wall_thick*2;
    //open places in the frame
    translate([0,-piece_h/2+20,0])hull()
    {
        translate([gap/2+3,0,0])square([ep,ep],center=true);
        translate([(support_depth-round*2)/2,42.5,0])square([support_depth-round*2-gap,ep],center=true);
    }
}
module opener_b()
{
    $fa=.5;
    $fs=.5;
    translate([round,0,0])hull()
    {
        translate([0,0,-m5_head-ep])linear_extrude(height=ep*2)minkowski()
        {
            frame_open_b();
            circle(r=round+1);
        }
        translate([0,0,-m5_head+1])linear_extrude(height=ep)minkowski()
        {
            frame_open_b();
            circle(r=round);
        }
    }
    translate([round,0,0])hull()
    {
        translate([0,0,-m5_head+1])linear_extrude(height=ep)minkowski()
        {
            frame_open_b();
            circle(r=round);
        }
        translate([0,0,m5_head-1-ep])linear_extrude(height=ep*2)minkowski()
        {
            frame_open_b();
            circle(r=round);
        }
    }
    translate([round,0,0])hull()
    {
        translate([0,0,m5_head-1-ep])linear_extrude(height=ep)minkowski()
        {
            frame_open_b();
            circle(r=round);
        }
        translate([0,0,m5_head-ep])linear_extrude(height=ep*2)minkowski()
        {
            frame_open_b();
            circle(r=round+1);
        }
    }
}
module frame_open_b()
{
    gap=inside_wall_thick*2;
    //open places in the frame
    translate([0,-piece_h/2+20,0])hull()
    {
        translate([(support_depth-round*2)/2,40.5+gap-2,0])square([support_depth-round*2-gap,ep],center=true);
        translate([gap/2,40.5+gap+32,0])square([ep,ep],center=true);
    }
}
module opener_c()
{
    $fa=.5;
    $fs=.5;
    translate([round,0,0])hull()
    {
        translate([0,0,-m5_head-ep])linear_extrude(height=ep*2)minkowski()
        {
            frame_open_c();
            circle(r=round+1);
        }
        translate([0,0,-m5_head+1])linear_extrude(height=ep)minkowski()
        {
            frame_open_c();
            circle(r=round);
        }
    }
    translate([round,0,0])hull()
    {
        translate([0,0,-m5_head+1])linear_extrude(height=ep)minkowski()
        {
            frame_open_c();
            circle(r=round);
        }
        translate([0,0,m5_head-1-ep])linear_extrude(height=ep*2)minkowski()
        {
            frame_open_c();
            circle(r=round);
        }
    }
    translate([round,0,0])hull()
    {
        translate([0,0,m5_head-1-ep])linear_extrude(height=ep)minkowski()
        {
            frame_open_c();
            circle(r=round);
        }
        translate([0,0,m5_head-ep])linear_extrude(height=ep*2)minkowski()
        {
            frame_open_c();
            circle(r=round+1);
        }
    }
}
module frame_open_c()
{
    gap=inside_wall_thick*2;
    //open places in the frame
    translate([0,-piece_h/2+20,0])hull()
    {
        translate([(support_depth-round*2)/2,40.5+gap+32+15,0])square([support_depth-round*2-gap,ep],center=true);
        translate([(support_depth-round*2)-gap/2,40.5+gap-2+15,0])square([ep,ep],center=true);
    }
}
module mount_holes()
{
    //m5 bolts
    for (bb=[-.5:1:.5])
    {
        translate([0,bb*mount_gap,0])rotate([0,0,-90])
        {
            translate([0,0,0])rotate([90,0,0])cylinder(r=m5_slot/2,h=50,$fn=20,center=true);
            translate([0,25+inside_wall_thick,0])rotate([90,0,0])cylinder(r=m5_head/2,h=50,$fn=20,center=true);   
        }
    }
}
