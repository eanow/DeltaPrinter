
plate_thick=2.5;
plate_l=114+4;
plate_w=90;
m3_slot=3.5;
m3nut_r=6.6/2;

cut_out_r=2.66;
board_lift=3; //minimum clearance for arduino thru hole pokies
post_h=board_lift+plate_thick;
$fa=.5;
$fs=.5;
//15mm from upper arduino hole to edge of PICA board
//29mm from upper outer hole to edge of PICA
fan_lift=6; //distance from edge of fan to floor
fan_r=75/2; //radius of 80mm fan portion
fan_hole_space=72;
fan_size=80;
fan_offset=45;

/*//PICA
translate([-(114-5)+106.9,-29-73.25+10,20])
{
    cube([114,95,3]);
    translate([-47,95-13-31.5,0])cube([47,13,3]);
    translate([-47,0+31.5,0])cube([47,13,3]);
}
*/
module base_plate()
{
    translate([plate_l/2,-plate_w/2,plate_thick/2])cube([plate_l,plate_w,plate_thick],center=true);
    
    //fan
    hull()
    {
        translate([plate_l-2,-plate_w/2,4.25])cube([4,plate_w,8.5],center=true);
        translate([plate_l-5,-plate_w/2,.25])cube([10,plate_w,.5],center=true);
    }
    hull()
    {
        translate([plate_l-2,-plate_w/2,4.25])cube([4,plate_w,8.5],center=true);
        translate([plate_l-2,-plate_w/2,15])cube([4,plate_w-15,fan_lift+10],center=true);
    }
}
module screw_cut()
{
    //posts
    rr=2;
    translate([25.72,-25.1,-1])cylinder(r=rr,h=post_h+2);
    translate([100.6,-25.1,-1])cylinder(r=rr,h=post_h+2);
    translate([24.5,-73.2,-1])cylinder(r=rr,h=post_h+2);
    translate([106.9,-73.25,-1])cylinder(r=rr,h=post_h+2);
}
module mount_post()
{
    rr1=6;
    rr2=3.5;
    translate([25.72,-25.1,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    translate([100.6,-25.1,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    translate([24.5,-73.2,0])cylinder(r1=rr1,r2=rr2,h=post_h);
    translate([106.9,-73.25,0])cylinder(r1=rr1,r2=rr2,h=post_h);
}
module fan()
{
    translate([plate_l,-fan_offset,fan_lift])
    {
        translate([0,0,fan_size/2])rotate([0,90,0])cylinder(r=fan_r,h=20,center=true);
        translate([0,0-fan_hole_space/2,fan_size/2-fan_hole_space/2])rotate([0,90,0])cylinder(r=m3_slot/2,h=20,center=true);
        translate([0,0+fan_hole_space/2,fan_size/2-fan_hole_space/2])rotate([0,90,0])cylinder(r=m3_slot/2,h=20,center=true);
        //hex
        translate([-4.5,0-fan_hole_space/2,fan_size/2-fan_hole_space/2])rotate([0,90,0])rotate([0,0,30])cylinder(r=m3nut_r,h=4,$fn=6,center=true);
        translate([-4.5,0+fan_hole_space/2,,fan_size/2-fan_hole_space/2])rotate([0,90,0])rotate([0,0,30])cylinder(r=m3nut_r,h=4,$fn=6,center=true);
    }
}
module tie_cut()
{
    translate([26,-18,0])cube([8,2,20],center=true);
    translate([101,-18,0])cube([8,2,20],center=true);
    translate([24.5,-80,0])cube([8,2,20],center=true);
    translate([107,-80,0])cube([8,2,20],center=true);
}
module final()
{
    difference()
    {
        union()
        {
            base_plate();
            translate([-10,10,0])mount_post();
            //translate([25,-35,plate_thick-.05])scale([.8,1,1])spine();
            //translate([25,-83,plate_thick-.05])scale([.8,1,1])spine();
            //translate([75,-73.5,plate_thick-.05])rotate([0,0,93])scale([.5,1,1])spine();
        }
        translate([-10,10,0])screw_cut();
        fan();
        translate([-10,10,0])tie_cut();
    }
}
final();
module spine()
{
    difference()
    {
        cube([100,20,5]);
        translate([0,-13.5,2-.1])spine_cut();
        translate([0,13.5,2-.1])spine_cut(); 
    }
}
module spine_cut()
{
    minkowski()
    {
        cube([100,20,5]);
        sphere(r=2);
    }
}
//spine();