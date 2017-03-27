$fa=1;
$fs=.5;
fansize=40;
corner_r=4;
nozzle_l=25;
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
    linear_extrude(height=.01)circle(r = size,center=true);
}
difference()
{
    union()
    {
        hull()
        {
            base(nozzle_r);
            translate([0,0,nozzle_l])tip(nozzle_r/2);
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
            translate([0, 0, +ep])translate([0,0,nozzle_l])tip((nozzle_r/2)-wall);
        }
    
    translate([-holespace/2,-holespace/2,bracket_h/2])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        translate([-holespace/2,holespace/2,bracket_h/2])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        translate([holespace/2,holespace/2,bracket_h/2])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
        translate([holespace/2,-holespace/2,bracket_h/2])cylinder(h=bracket_h*2,r=(m3_slot/2),center=true);
}