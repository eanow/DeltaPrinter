magnet_r=11.8/2;
hh=20;

chop_h=15;

intersection()
{
    rotate([30,0,0])translate([0,0,-5])cylinder(r=magnet_r,h=hh,$fn=50);
    translate([0,0,chop_h/2])cube([50,50,chop_h],center=true);
}