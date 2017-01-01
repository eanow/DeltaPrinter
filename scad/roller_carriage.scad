extrusion_width=20; //extrusion that the carriage is intended to fit around
roller_axle_w=5.31; //width of the fixed portion of the captive bearing
axle_r=5/2+.2;
roller_fixed_axle_r=8.5/2;
roller_diameter=21.44;
roller_inset=2.01;  //how far into the extrusion groove the roller fits
roller_gap_h=66; //distance, center to center, of the two rollers ont he same side
roller_thick=7;
carriage_thick=8; //thickness of the carriage, when considering it as a mostly flat slab
carriage_clearance=1; //gap between carriage and extrusion
slider_r=4/2;
ep=0.01;

//carriage is designed in usage orientation
    xx=roller_diameter/2+extrusion_width/2-roller_inset;
    zz=roller_gap_h/2;
    yy=extrusion_width/2+carriage_clearance+carriage_thick;
    hh=((extrusion_width+carriage_thick*2+carriage_clearance*2)-roller_axle_w)/2;
module roller_axles()
{
    //place three axles that hold the rollers
    translate([xx,yy,0])rotate([90,0,0])roller_axle();
    translate([-xx,yy,zz])rotate([90,0,0])roller_axle();
    translate([-xx,yy,-zz])rotate([90,0,0])roller_axle();
}
module axle_cuts()
{
    translate([xx,yy,0])rotate([90,0,0])translate([0,0,-hh/2])cylinder(r=axle_r,h=hh*2,$fn=20);
    translate([-xx,yy,zz])rotate([90,0,0])translate([0,0,-hh/2])cylinder(r=axle_r,h=hh*2,$fn=20);
    translate([-xx,yy,-zz])rotate([90,0,0])translate([0,0,-hh/2])cylinder(r=axle_r,h=hh*2,$fn=20);
}
module roller_axle()
{
    //axles are a cone
    cone_fatness=4;
    $fa=1;
    $fs=1;
    
    difference()
    {
        cylinder(r1=roller_fixed_axle_r+cone_fatness,r2=roller_fixed_axle_r,h=hh);
        translate([0,0,-hh/2])cylinder(r=axle_r,h=hh*2,$fn=20);
    }
}
module carriage_plate()
{
    //round bits at axles
    hh=carriage_thick;
    cone_fatness=4;
    hull()
    {
        translate([-xx,yy,-zz])rotate([90,0,0])cylinder(r=roller_fixed_axle_r+cone_fatness,h=hh);
        translate([0,yy,-zz])rotate([90,0,0])translate([0,(roller_fixed_axle_r+cone_fatness),carriage_thick/2])cube([1,4*(roller_fixed_axle_r+cone_fatness),carriage_thick],center=true);
    }
    hull()
    {
        translate([-xx,yy,zz])rotate([90,0,0])cylinder(r=roller_fixed_axle_r+cone_fatness,h=hh);
        translate([0,yy,zz])rotate([90,0,0])translate([0,-(roller_fixed_axle_r+cone_fatness),carriage_thick/2])cube([1,4*(roller_fixed_axle_r+cone_fatness),carriage_thick],center=true);
    }
    //bendy annulus
    outer_r=xx+cone_fatness+roller_fixed_axle_r-extrusion_width/2;
    inner_r=8;
    tall=roller_gap_h+2*cone_fatness+2*roller_fixed_axle_r;
    translate([extrusion_width/2,yy,tall/2-outer_r])rotate([90,0,0])difference()
    {
        cylinder(r=outer_r,h=carriage_thick);
        translate([0,0,-carriage_thick/2])cylinder(r=inner_r,h=carriage_thick*2);
        translate([0,-outer_r,carriage_thick/2])cube([outer_r*4,outer_r*2,carriage_thick*2],center=true);
    }
    hull()
    {
        translate([xx,yy,0])rotate([90,0,0])cylinder(r=roller_fixed_axle_r+cone_fatness,h=hh);
        translate([extrusion_width/2,yy,tall/2-outer_r])rotate([90,0,0])translate([inner_r+(outer_r-inner_r)/2,0,carriage_thick/2])cube([outer_r-inner_r,.1,carriage_thick],center=true);
    }
    //central spine
    translate([0,yy,0])rotate([90,0,0])translate([0,0,carriage_thick/2])cube([extrusion_width,tall,carriage_thick],center=true);
    //pinch grabber
    pinch_width=5;
    translate([xx+cone_fatness+roller_fixed_axle_r-pinch_width/2,yy,0])rotate([90,0,0])translate([0,0,carriage_thick/2])cube([pinch_width,45,carriage_thick],center=true);
    //captive block
    pinch_gap=2;
    captive_width=xx+roller_fixed_axle_r+cone_fatness-extrusion_width/2-pinch_gap-pinch_width;
    translate([extrusion_width/2+captive_width/2-ep,yy,-22.5+5])rotate([90,0,0])translate([0,0,carriage_thick/2])cube([captive_width,15,carriage_thick],center=true);
    //enstop hitter
    translate([-xx,yy,tall/2])rotate([90,0,0])linear_extrude(hh)minkowski()
    {
        square([6,16],center=true);
        circle(r=2,$fn=30);
    }
}
module captive_cuts()
{
    m3nut_r=6.6/2;
    m3nut_t=3;
    m3slot=3.5;
    slot_d=m3nut_r*sqrt(3);
    translate([20,yy-carriage_thick/2,-22.5+5])rotate([0,90,0])cylinder(r=m3slot/2,h=20,center=true,$fn=20);
    translate([20-4,yy-carriage_thick/2,-22.5+5])rotate([30,0,0])rotate([0,90,0])cylinder(r=m3nut_r,h=m3nut_t,center=true,$fn=6);
    translate([20-4,yy-carriage_thick,-22.5+5])cube([m3nut_t,carriage_thick,slot_d],center=true);
    //mounting holes
    translate([0,extrusion_width/2+m3nut_t/2+carriage_clearance-ep,(roller_gap_h/2-m3nut_r*2)])rotate([90,0,0])
    {
        cylinder(r=m3nut_r,h=m3nut_t,$fn=6,center=true);
        cylinder(r=m3slot/2,h=carriage_thick*2,$fn=20,center=true);
    }
    translate([0,extrusion_width/2+m3nut_t/2+carriage_clearance-ep,-(roller_gap_h/2-m3nut_r*2)])rotate([90,0,0])
    {
        cylinder(r=m3nut_r,h=m3nut_t,$fn=6,center=true);
        cylinder(r=m3slot/2,h=carriage_thick*2,$fn=20,center=true);
    }
    //small carve out of the spine for the flexy bit
    intersection()
    {
        translate([xx,yy+1,0])rotate([90,0,0])cylinder(r=roller_fixed_axle_r+4+3,h=hh);
        translate([0+ep,yy,0])rotate([90,0,0])translate([0,0,carriage_thick/2])cube([extrusion_width,roller_gap_h,carriage_thick+1],center=true);
    }
}
module slider_cuts()
{
    translate([0,extrusion_width/2+slider_r,roller_gap_h/2+2])rotate([0,90,0])cylinder(r=slider_r,h=extrusion_width+1,$fn=20,center=true);
    translate([0,extrusion_width/2+slider_r,-(roller_gap_h/2+2)])rotate([0,90,0])cylinder(r=slider_r,h=extrusion_width+1,$fn=20,center=true);
}
module final()
{
    difference()
    {
        union()
        {
            carriage_plate();
            roller_axles();
        }
        axle_cuts();
        captive_cuts();
        slider_cuts();
    }
}
final();
//mockups();
module mockups()
{
    //extrusion
    side=20;    //size of a side of the extrusion
    slot=6;     //width of the slots, on the face
    central=8;  //how wide the central pillar is; the slot depth is then (side-central)/2
    color([.3,.3,.3])translate([0,0,-100])linear_extrude(height=200)difference()
    {
        //main body
        square([side,side],center=true);
        //track slots
        translate([side/2+central/2,0])square([side,slot],center=true);
        translate([-(side/2+central/2),0])square([side,slot],center=true);
        translate([0,side/2+central/2])square([slot,side],center=true);
        translate([0,-(side/2+central/2)])square([slot,side],center=true);
    }
    //wheels
    xx=roller_diameter/2+extrusion_width/2-roller_inset;
    zz=roller_gap_h/2;
    color([.95,.95,.95])
    {
        translate([xx,0,0])rotate([90,0,0])difference()
        {
            cylinder(r=roller_diameter/2,h=roller_thick,center=true);
            cylinder(r=axle_r,h=roller_thick*2,center=true);
        }
        translate([-xx,0,zz])rotate([90,0,0])difference()
        {
            cylinder(r=roller_diameter/2,h=roller_thick,center=true);
            cylinder(r=axle_r,h=roller_thick*2,center=true);
        }
        translate([-xx,0,-zz])rotate([90,0,0])difference()
        {
            cylinder(r=roller_diameter/2,h=roller_thick,center=true);
            cylinder(r=axle_r,h=roller_thick*2,center=true);
        }
    }
    //ptfe sliders
    
    color([1,1,1])
    {
        translate([0,extrusion_width/2+slider_r,roller_gap_h/2+2])rotate([0,90,0])cylinder(r=slider_r,h=20-.1,$fn=20,center=true);
        translate([0,extrusion_width/2+slider_r,-(roller_gap_h/2+2)])rotate([0,90,0])cylinder(r=slider_r,h=20-.1,$fn=20,center=true);
    }
}
