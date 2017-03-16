

back_d=52.7;
metal_thick=3.5;
$fs=.5;
$fa=2;
lip=6.6;
back_t=1;
thick=4;
mount_d=46.86;
mount_s=2.6;
screw_head_r=4.75/2;


hole_d=30;
mount_r=7;

piston_offset=6.3;
module bracket()
{
    b_t=5;
    ep=.001;

    difference()
    {
        cylinder(r=back_d/2+2.4,h=b_t);
        //screw holes
        for (ii=[0:4])
        {
            rotate(ii*90+45,[0,0,1])translate([mount_d/2,0,-back_t+back_t/2])cylinder(r1=mount_s/2,r2=mount_s/2,h=back_t*2);
        }
        //groove
        translate([0,0,-ep])difference()
        {
            cylinder(r1=back_d/2+1, r2=back_d/2+.5, h=back_t+ep*2);
            cylinder(r1=back_d/2-.5, r2=back_d/2, h=back_t+ep*2);
        }
    }
}

bracket();

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
    }
}

top_plate_shape();