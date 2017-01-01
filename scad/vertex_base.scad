include <config.scad>;
module final()
{
    difference()
    {
        union()
        {
            linear_extrude(height=piece_h)base_shape();
            translate([0,0,piece_h-side])align_bumps();
            align_bumps();
            //anti-scratch
            translate([(-side/2)+vertex_rad-vert_inset,0,0])linear_extrude(1)square([side+1+ep,side+1+ep],center=true);
        }
        translate([0,0,piece_h-side])m5_holes();
        m5_holes();
        stepper_mount();
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
module stepper_mount()
{
    nema_boss_size = 27;
    // Spacing between M3 holes on nema
    nema_hole_spacing = 31;
    xx=vertex_rad-vert_inset-side-inside_wall_thick-channel_width-inside_wall_thick/2;
    translate([xx,0,piece_h/2])rotate([0,90,0])translate([0,0,-inside_wall_thick])linear_extrude(inside_wall_thick*2)
    {
        //motor boss
        circle(r=nema_boss_size/2,$fn=100);
        //printability
        intersection()
        {
            rotate([0,0,45])square([nema_boss_size,nema_boss_size],center=true);
            translate([-nema_boss_size*sqrt(2)/2,0])square([nema_boss_size/sqrt(2),nema_boss_size/sqrt(2)],center=true);
        }
    }
    translate([xx,0,piece_h/2])rotate([0,90,0])translate([0,0,-inside_wall_thick])linear_extrude(vertex_rad*4+inside_wall_thick*2)
    {
        //m3 holes
        for (aa=[-.5:1:.5])
        {
            for (bb=[-.5:1:.5])
            {
                translate([aa*nema_hole_spacing,bb*nema_hole_spacing])circle(r=m3_slot/2,$fn=50);
            }
        }
    }
}

module nut_slots()
{
    //rotate([0,0,60])translate([-side/2+vertex_rad,0,piece_h+ep])nut_fill();
    rotate([0,0,-60])translate([-side/2+vertex_rad,0,piece_h+ep])nut_fill();
    rotate([0,0,60])translate([vertex_rad+ep,0,side/2])rotate([0,90,0])nut_fill();
    rotate([0,0,60])translate([vertex_rad+ep,0,piece_h-side/2])rotate([0,90,0])nut_fill();
    
}
final();

//m5_holes();
//motor_gap();
//triangle
//circle(r=30,center=true,$fn=3);