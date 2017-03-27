module hotend()
{
    translate([0,0,-8.65])rotate([90,0,0])import("../stl/e3dmockup.stl");
}

//color([.8,.8,.8])hotend();
module effector()
{
    import("../stl/effector_tension.stl");
}
module hotend_mount()
{
    import("../stl/e3d_mount.stl");
}
//color([.3,.3,.9])hotend_mount();
//color([.3,.3,.9])effector();
ep=0.01;
//m3 hardware numbers that work
m3nut_r=6.6/2;
m3nut_t=3;
m3slot=3.5;
slot_d=m3nut_r*sqrt(3);

arm_gap=40; //center to center

base_thick=12;

$fa=1;
$fs=.5;

effector_d=60;
hole_d=30;

//ball_d=9.5+.6;
//socket_lift=6;



module eff_mount_holes()
{
    cylinder(r=hole_d/2,h=base_thick*4,center=true);
    for (aa=[60:120:300])
    {
        rotate([0,0,aa]) 
        {
            translate([hole_d/2+8,0,0])cylinder(r=m3slot/2,h=base_thick*5,center=true);
            translate([hole_d/2+8,0,-ep-.5-2])cylinder(r=m3nut_r,h=m3nut_t+.5+2,$fn=6);
            rotate([0,0,60])translate([effector_d/2*.65,0,0])cylinder(r=m3slot/2,h=base_thick*4,center=true);
        }
    }
}

module plate()
{
    bracket_r=(effector_d/2+5);
    //plate that attaches to the effector
    difference()
    {
        union()
        {
            hull()
            {
                rotate([0,0,-30])translate([0,-fan_yy,-fan_zz])rotate([-(90+fan_angle),0,0])translate([0,-20,-bracket_h/2])cube([40,4,bracket_h],center=true);
                rotate([0,0,-30])translate([0,-(bracket_r-2),0])cube([fansize,8,1],center=true);
                
            }
            hull()
            {
                rotate([0,0,30])translate([0,fan_yy,-fan_zz])rotate([(90+fan_angle),0,0])translate([0,20,-bracket_h/2])cube([40,4,bracket_h],center=true);
                rotate([0,0,30])translate([0,(bracket_r-2),0])cube([fansize,8,1],center=true);
                
            }
            rotate([0,0,-30])translate([0,-bracket_r/2,0])cube([fansize,bracket_r,5],center=true);
            rotate([0,0,30])translate([0,bracket_r/2,0])cube([fansize,bracket_r,5],center=true);
        }
    }
}
difference()
{
    plate();
    eff_mount_holes();
    translate([0,0,5-.5])cube([100,100,10],center=true);
    translate([51,0,0])cube([100,100,10],center=true);
}

//nozzle stuff
module nozzle()
{
    import("../stl/nozzle.stl");
}

fansize=40;
corner_r=4;
nozzle_r=18;
fan_yy=47;
fan_zz=24;
fan_angle=35;
holespace=32;
bracket_h=6;


//translate([0,47,-20])rotate([135,0,0])nozzle();
rotate([0,0,-30]){
    translate([0,-fan_yy,-fan_zz])rotate([-(90+fan_angle),0,0])translate([0,0,-bracket_h])nozzle_bracket();
    //translate([0,-fan_yy,-fan_zz])rotate([-(90+fan_angle),0,0])nozzle();
}
rotate([0,0,30]){
    translate([0,fan_yy,-fan_zz])rotate([(90+fan_angle),0,0])translate([0,0,-bracket_h])nozzle_bracket();
    //translate([0,fan_yy,-fan_zz])rotate([(90+fan_angle),0,0])nozzle();
}
module nozzle_bracket()
{
linear_extrude(height=bracket_h)difference()
    {
        minkowski()
        {
            square([fansize-(corner_r*2),fansize-(corner_r*2)],center=true);
            circle(r=corner_r);
        }
        circle(r = nozzle_r,center=true);
        translate([-holespace/2,-holespace/2])circle(r=(m3slot/2),center=true);
        translate([-holespace/2,holespace/2])circle(r=(m3slot/2),center=true);
        translate([holespace/2,holespace/2])circle(r=(m3slot/2),center=true);
        translate([holespace/2,-holespace/2])circle(r=(m3slot/2),center=true);
    }
}
