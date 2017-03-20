

back_d=52.7;
metal_thick=3.5;
mount_h=3;
$fs=.5;
$fa=2;
lip=6.6;
back_t=1;
thick=4;
mount_d=46.86;
mount_s=2.6;
screw_head_r=4.75/2;
m3slot=3.5;


hole_d=30;
mount_r=7;

piston_offset=6.3;
module bracket()
{
    b_t=5;
    ep=.001;

    difference()
    {
        union()
        {
            cylinder(r=back_d/2+2.4,h=b_t);
            translate([0,20-.5-.1,b_t/2])rotate([0,0,45])cube([30,30,b_t],center=true);
        }
        //screw holes
        for (ii=[0:4])
        {
            rotate(ii*90+45,[0,0,1])translate([mount_d/2,0,-back_t+back_t/2])cylinder(r1=mount_s/2,r2=mount_s/2,h=back_t*2);
            translate([0,0,b_t-.6])rotate(ii*90+45,[0,0,1])translate([mount_d/2,0,-back_t+back_t/2])cylinder(r=screw_head_r,h=b_t,center=true);
        }
        //groove
        translate([0,0,-ep])difference()
        {
            cylinder(r1=back_d/2+1, r2=back_d/2+.5, h=back_t+ep*2);
            cylinder(r1=back_d/2-.5, r2=back_d/2, h=back_t+ep*2);
        }
    }
    
}
difference()
{
    translate([-piston_offset,0,33])rotate([0,0,90])rotate([-90,0,0])bracket();
    translate([0,0,-25])cube([200,200,50],center=true);
}

//three mount points
module top_plate_shape()
{
    difference()
    {
        hull()
        {
            for (aa=[60:120:300])
            {
                rotate([0,0,aa])translate([hole_d/2+8,0])circle(r=mount_r);
            }
        }
        for (aa=[0:120:300])
        {
            rotate([0,0,aa])translate([hole_d/2+6,0])circle(r=5);//rotate([0,0,45])square([10,10],center=true);
        }
        circle(r=10.6/2);
        for (aa=[60:120:300])
        {
            rotate([0,0,aa])translate([hole_d/2+8,0])circle(r=m3slot/2);
        }
    }
}

linear_extrude(height=mount_h)top_plate_shape();