//print with no infill so that it only prints perimeters (and the bottom)

bottom_t=2;
sidewall=.79;
rod_r=6/2+.2; //.2 too small .4 too big
cap_l=15;
ep=0.01;
$fn=60;
m4_tap=4;

difference()
{
    union()
    {
        translate([0,0,1])cylinder(r=rod_r+sidewall,h=cap_l-1);
        cylinder(r1=rod_r+sidewall-1,r2=rod_r+sidewall,h=1+ep);
    }
    translate([0,0,bottom_t])cylinder(r=rod_r,h=cap_l);
    cylinder(r=m4_tap/2,h=cap_l*4,center=true);
}