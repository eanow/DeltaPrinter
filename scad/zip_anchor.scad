anchor_w=15;
anchor_l=22;
bh=3;
difference()
{
    hull()
    {
        translate([0,0,bh/2+.5])cube([anchor_w,anchor_l,bh],center=true);
        translate([0,0,(bh-1)/2])cube([anchor_w-1,anchor_l-1,bh-1],center=true);
        translate([0,0,2+2])cube([anchor_w/2,anchor_l/2,4+2],center=true);
    }
    //annulus
    $fn=50;
    translate([0,0,12+1.5])rotate([90,0,0])difference()
    {
        cylinder(r=12,h=4,center=true);
        cylinder(r=10,h=5,center=true);
    }
}