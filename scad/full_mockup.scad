//2020 extrusion
extrusion_w=20;
//base
base_ext_l=290;
//risers
riser_ext_l=650;
//vertex info
vertex_rad=40;
vert_inset=6;
//printbed
bed_d=220;
//height of the base frame
base_h=50;
//effector effective radius (accounting for the magnetic mount tilt)
eff_r=27;
eff_h=62+10;

//geometry
alt=(sqrt(3.0)/2.0)*base_ext_l;
centroid_arm=(sqrt(3.0)/3.0)*base_ext_l;
riser_offset=centroid_arm+vertex_rad-extrusion_w/2-vert_inset;
//carriage radius; effective distance of the center to the ball mounts on the carriage
carriage_r=riser_offset-30;
carriage_h=70/2; //carriage height above rod mounts


//arm math
lower_angle=25; //degree from horizontal for arm at edge of bed
base=carriage_r+bed_d/2-eff_r;
arm_l=base/cos(lower_angle);
echo("minimum arm length",arm_l);
//vertical available
near_base=carriage_r-bed_d/2-eff_r;
echo(near_base);
vert_pos=sqrt((arm_l*arm_l)-(near_base*near_base));
echo(vert_pos);
vert_travel=riser_ext_l-base_h-extrusion_w-4-eff_h-carriage_h-vert_pos;
echo("estimated vertical travel space",vert_travel);



frame();
bed();
carriage();
//arms();
nema_dummy();
//%translate([0,0,150])cube([carriage_r*2,carriage_r*2,300],center=true);
module nema_dummy()
{
    aa=8; //pully location
    bb=26.5; //motor position
    translate([centroid_arm-bb,0,22])rotate([0,90,0])
    {
        translate([0,0,-24])color([.1,.1,.1])cube([43,43,48],center=true);
        translate([0,0,-48])color([.5,.5,.5])cylinder(r=5/2,h=24+48);
        translate([0,0,8+aa])cylinder(r=12.2/2,h=16,center=true);
    }
}
module arms()
{
    translate([-bed_d/2+eff_r,20,base_h+eff_h])rotate([0,90-lower_angle,0])cylinder(r=3,h=arm_l);
    translate([-bed_d/2+eff_r,-20,base_h+eff_h])rotate([0,90-lower_angle,0])cylinder(r=3,h=arm_l);
}
module carriage()
{
    roller_offset=19;
    translate([riser_offset,0,200])rotate([0,0,90])import("../stl/roller_carriage.stl");
    translate([riser_offset-roller_offset,0,200])rotate([0,-90,0])rotate([0,0,-90])import("../stl/carriage_mount.stl");
}
module bed()
{
    color([.8,.2,.2])translate([0,0,base_h+1])cylinder(r=bed_d/2,h=3);
}
module frame()
{
    //top
    translate([0,0,riser_ext_l-extrusion_w])for (aa=[0:120:240])
    {    
        rotate([0,0,aa])translate([centroid_arm,0,0])
        {
            color([.2,.2,.9])import("../stl/vertex.stl");
            rotate([0,0,60])translate([vertex_rad-extrusion_w/2,base_ext_l/2,extrusion_w/2])
            {
                color([.4,.4,.4])cube([extrusion_w,base_ext_l,extrusion_w],center=true);
            }
        }
    }
    for (aa=[0:120:240])
    {    
        rotate([0,0,aa])translate([centroid_arm,0,0])
        {
            color([.2,.2,.9])import("../stl/vertex_base.stl");
            rotate([0,0,60])translate([vertex_rad-extrusion_w/2,base_ext_l/2,extrusion_w/2])
            {
                color([.4,.4,.4])cube([extrusion_w,base_ext_l,extrusion_w],center=true);
            }
            rotate([0,0,60])translate([vertex_rad-extrusion_w/2,base_ext_l/2,base_h-extrusion_w/2])
            {
                color([.4,.4,.4])cube([extrusion_w,base_ext_l,extrusion_w],center=true);
            }
        }
    }
    for (aa=[0:120:240])
    { 
        rotate([0,0,aa])translate([centroid_arm+vertex_rad-extrusion_w/2-vert_inset,0,riser_ext_l/2])
        {
            color([.4,.4,.4])cube([extrusion_w,extrusion_w,riser_ext_l],center=true);
        }
    }
}


