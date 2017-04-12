$fa=1;
$fs=1;
fansize=40;
corner_r=4;
nozzle_l=28;
ep=0.001;
nozzle_r=19;
scale=.5;
holespace=32;
m3_slot=3.5;
bracket_h=2;
wall=.6;
module base(size)
{
    linear_extrude(height=.01)circle(r = size,center=true);
}
module tip(size)
{
    //rotate([0,-20,0])linear_extrude(height=.01)circle(r = size,center=true);
    rotate([20,-20,-15])linear_extrude(height=.01)square([size*2,size],center=true);
}
tip_x=5;
tip_y=3;
difference()
{
    union()
    {
        minkowski()
        {
            hull()
            {
                base(nozzle_r);
                translate([tip_x,tip_y,nozzle_l])tip((nozzle_r/2)-wall);
            }
                sphere(r=wall);
        }
        translate([0,0,0])linear_extrude(height=bracket_h)minkowski()
        {
            square([fansize-(corner_r*2),fansize-(corner_r*2)],center=true);
            circle(r=corner_r);
        }
    }
    hull()
        {
            translate([0, 0, -ep])base(nozzle_r-wall);
            translate([0, 0, +ep])translate([tip_x,tip_y,nozzle_l])tip((nozzle_r/2)-wall);
        }
    
    translate([-holespace/2,-holespace/2,bracket_h/2])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        translate([-holespace/2,holespace/2,bracket_h/2])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        translate([holespace/2,holespace/2,bracket_h/2])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        translate([holespace/2,-holespace/2,bracket_h/2])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        
        translate([0,0,-50])cube([100,100,100],center=true);
        hull()
        {
            translate([tip_x,tip_y,nozzle_l])tip((nozzle_r/2)-wall);
            translate([tip_x,tip_y,nozzle_l+wall*2])tip((nozzle_r/2)-wall);
        }
}
//import("../stl/nozzle.stl");