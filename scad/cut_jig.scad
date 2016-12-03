rod_r=6/2+.2; //.4 too big, 0 too small
m4_r=4.5/2-.2;
difference()
{
    union()
    {
        translate([0,15/2,35/2])cube([20,15,35],center=true);
        cylinder(r=20/2,h=35);
    }
    translate([0,0,-1])cylinder(r=rod_r,h=40,$fn=20);
    translate([0,0,-0.01])cylinder(r2=rod_r,r1=rod_r+1,h=1,$fn=20);
    //cutout
    translate([0,10,19])cube([3,20,40],center=true);
    //screw close
    translate([0,8,10])rotate([0,90,0])cylinder(r=5.5/2,h=40,center=true);
    translate([15,8,10])rotate([0,90,0])cylinder(r=9.3/2,h=20,center=true,$fn=6);
    translate([0,8,25])rotate([0,90,0])cylinder(r=5.5/2,h=40,center=true);
    translate([15,8,25])rotate([0,90,0])cylinder(r=9.3/2,h=20,center=true,$fn=6);
}

translate([0,0,35-0.01])difference()
{
    union()
    {
        translate([0,15/2,35/2])cube([20,15,35],center=true);
        cylinder(r=20/2,h=35);
    }
    translate([0,0,-1])cylinder(r=rod_r,h=40,$fn=20);

    //cutout
    translate([0,10,19])cube([3,20,40],center=true);
    //screw close
    translate([0,8,10])rotate([0,90,0])cylinder(r=5.5/2,h=40,center=true);
    translate([15,8,10])rotate([0,90,0])cylinder(r=9.3/2,h=20,center=true,$fn=6);
    translate([0,8,25])rotate([0,90,0])cylinder(r=5.5/2,h=40,center=true);
    translate([15,8,25])rotate([0,90,0])cylinder(r=9.3/2,h=20,center=true,$fn=6);
    translate([0,10,1])cube([21,26,2.01],center=true);
}

