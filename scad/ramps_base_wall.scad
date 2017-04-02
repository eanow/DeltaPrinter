include <config.scad>;
include <base_config.scad>;

base_ext_l=331;
fan_offset=80; //mm from center to center of 80mm fan
fit_tolerance=.5; //added gap between elements
fan_inset=1.6;
fan_r=75/2;
fan_border=5;
fan_hole_space=72;

truss_wall=2.39;

bevel=.5;

//edge to (centerline) holes
eth=(base_ext_l)/2;
//additional added to where the two plates overlap
//total plate width
pw=eth+dual_overlap-fit_tolerance*2;
plate_round=2;
//plate height
ph=vertical_buffer+atx_height-fit_tolerance*2; //tolerance gap top and bottom

switch_width=12.6+fit_tolerance;
switch_height=18.85+fit_tolerance;
switch_buffer=10;

left();
//right();

module left()
{
    translate([.5*(pw)+fit_tolerance-base_ext_l/2,0,0])
    {
        difference()
        {
            union()
            {
                rough_shape();
                
            }
            truss_grid(truss_wall);
            mirror([0,1,0])truss_grid(truss_wall);
            m3_holes();
            m4_hole();
            //fan();
            overlap_cut();
        }
        
        difference()
        {
            m4_mount();
            m4_hole();
        }
        difference()
        {
            //fan_mount();
            //fan();
        }
    }
}
module right()
{
    mirror([1,0,0])
    {
        translate([.5*(pw)+fit_tolerance-base_ext_l/2,0,0])
        {
            difference()
            {
                union()
                {
                    rough_shape();
                }
                truss_grid(truss_wall);
                mirror([0,1,0])truss_grid(truss_wall);
                m3_holes();
                m4_hole();
                translate([0,0,grid_wall_thick])overlap_cut();
                //translate([-tw0*1,0,0])switch_hole();
            }
            
            difference()
            {
                m4_mount();
                m4_hole();
            }
            translate([-tw0*1,0,0])difference()
            {
                //switch();
                //switch_hole();
            }
        }
    }
}

module switch()
{
    
    hull()
    {
        //inside bevel
        linear_extrude(height=grid_wall_thick)
        {
            minkowski()
            {
                square([switch_width+switch_buffer-plate_round*2,switch_height+switch_buffer-plate_round*2,],center=true);
                circle(r=plate_round-bevel,$fn=40);
            }
        }
        //outside
        translate([0,0,bevel])linear_extrude(height=grid_wall_thick-bevel*2)
        {
            minkowski()
            {
                square([switch_width+switch_buffer-plate_round*2,switch_height+switch_buffer-plate_round*2,],center=true);
                circle(r=plate_round,$fn=40);
            }
        }
    }
}
module switch_hole()
{
    cube([switch_width,switch_height,grid_wall_thick*3],center=true);
}
module fan()
{
    //translate([pw/2+fit_tolerance-dual_overlap-fan_offset,0,-12.5+grid_wall_thick-fan_inset])
    translate([0,0,-12.5+grid_wall_thick-fan_inset])
    {
        cube([80+fit_tolerance*2,80+fit_tolerance*2,25],center=true);
        //%cylinder(r=fan_r,h=60,center=true);
        for(aa=[-.5:1:.5])
        {
            for(bb=[-.5:1:.5])
            {
                translate([aa*fan_hole_space,bb*fan_hole_space,0])cylinder(r=m3_slot/2,h=2*grid_wall_thick+ep*2);
            }
        }
    }
}
module fan_mount()
{
    buffer=1.2;
    //translate([pw/2+fit_tolerance-dual_overlap-fan_offset,0,0])
    {
        for(aa=[-.5:1:.5])
        {
            for(bb=[-.5:1:.5])
            {
                translate([aa*fan_hole_space,bb*fan_hole_space,0])
                {
                cylinder(r1=m3nut_r+buffer-bevel,r2=m3nut_r+buffer,h=bevel);
                    translate([0,0,bevel])cylinder(r=m3nut_r+buffer,h=grid_wall_thick-bevel*2);
                    translate([0,0,grid_wall_thick-bevel])cylinder(r2=m3nut_r+buffer-bevel,r1=m3nut_r+buffer,h=bevel);
                }
            }
        }
    }
}


module overlap_cut()
{
    translate([pw/2+fit_tolerance,0,0])cube([dual_overlap*4,ph*2,grid_wall_thick],center=true);
}
//m3 holes
module m3_holes()
{
    for(aa=[-.5:1:.5])
    {
    translate([-(pw)/2-fit_tolerance+wall_screw_horz,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep])cylinder(r=m3_slot/2,h=grid_wall_thick+ep*2);
        translate([-(pw)/2-fit_tolerance+wall_screw_horz,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep+grid_wall_thick-m3nut_t])cylinder(r=m3_head_r,h=m3nut_t*2);
        translate([-(pw)/2-fit_tolerance+wall_screw_horz,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep+grid_wall_thick-m3nut_t-1])cylinder(r2=m3_head_r,r1=m3_slot/2,h=1+ep);
    }
    //overlap portion
    for(aa=[-.5:1:.5])
    {
    translate([(pw)/2+fit_tolerance-dual_overlap,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep])cylinder(r=m3_slot/2,h=grid_wall_thick+ep*2);
        //hex
        hull()
        {
        translate([(pw)/2+fit_tolerance-dual_overlap,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep])cylinder(r=m3nut_r,h=1.5,$fn=6);
            translate([(pw)/2+fit_tolerance-dual_overlap,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep])cylinder(r=m3_slot/2,h=2.5,$fn=6);
        }
        
        translate([(pw)/2+fit_tolerance-dual_overlap,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep+grid_wall_thick-m3nut_t])cylinder(r=m3_head_r,h=m3nut_t*2);
        
        translate([+(pw)/2+fit_tolerance-dual_overlap,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep+grid_wall_thick-m3nut_t-1])cylinder(r2=m3_head_r,r1=m3_slot/2,h=1+ep);
    }
}


//m4 mount hole, for connection to frame
module m4_mount()
{
    translate([20-(pw)/2-fit_tolerance+wall_screw_horz+1.5*m3_slot,ph/2-(m4_nut_r+2.0),0])
    {
        cylinder(r1=m4_nut_r+2-bevel,r2=m4_nut_r+2,h=bevel);
        translate([0,0,bevel])cylinder(r=m4_nut_r+2,h=grid_wall_thick-bevel*2);
        translate([0,0,grid_wall_thick-bevel])cylinder(r2=m4_nut_r+2-bevel,r1=m4_nut_r+2,h=bevel);
    }
}
module m4_hole()
{
    translate([20-(pw)/2-fit_tolerance+wall_screw_horz+1.5*m3_slot,ph/2-(m4_nut_r+2.0),-ep])
    {
        cylinder(r=m4_slot/2,h=grid_wall_thick+ep*2);
        hull()
        {
            cylinder(r=m4_nut_r,h=m3nut_t,$fn=6);
            cylinder(r=m4_slot/2,h=m3nut_t+1,$fn=6);
        }
    }
}


module rough_outline(pr)
{
    //rough rectangle, one tolerance at edge by post
    minkowski()
    {
        square([pw-plate_round*2,ph-plate_round*2],center=true);
        circle(r=pr,$fn=40);
    }
}

module rough_shape()
{
    //bevel
    hull()
    {
        translate([0,0,grid_wall_thick-ep])linear_extrude(height=ep)rough_outline(plate_round-bevel);
        translate([0,0,grid_wall_thick-bevel-ep])linear_extrude(height=ep)rough_outline(plate_round);
    }
    translate([0,0,bevel])linear_extrude(height=grid_wall_thick-bevel*2)rough_outline(plate_round);
    hull()
    {
        translate([0,0,0])linear_extrude(height=ep)rough_outline(plate_round-bevel);
        translate([0,0,bevel])linear_extrude(height=ep)rough_outline(plate_round);
    }
        
}



    //space occupied
    //distance between screw hole on post, and wall on atx bracket
    //linear_x=(base_ext_l-atx_width)/2-wall_screw_horz-bracket_wall-1.5*m3_slot;
    //we will arrange two rows of triangles
    triangle_height_0=fan_r;
    //assuming equilateral triangles,
    ideal_width=2*triangle_height_0/sqrt(3);
    //how many triangles?
    triangle_num=1;//round(linear_x/ideal_width);
    //width of triangles
    triangle_width_0=ideal_width;
    th0=triangle_height_0;
    tw0=triangle_width_0;
    te0=sqrt(th0*th0+(tw0/2*tw0/2));
    base_angle=acos((tw0/2)/te0);
    tip_angle=180-(base_angle*2);

module truss_grid(wall)
{
    //translate([pw/2+fit_tolerance-fan_offset,0,0])
    {
        //down tris
        for (aa=[-1:1:1])
        {
            translate([tw0*aa,0,0])down_vol(wall);
        }
        //up tris
        for (aa=[-1:1:0])
        {
            translate([tw0*.5+tw0*aa,0,0])up_vol(wall);
        }
        //ends
        translate([tw0,0,0])right_up_vol(wall);
        translate([-tw0,0,0])left_up_vol(wall);
    }
}
module up_vol(wall)
{
    //center triangle
    hull()
    {
        //top
        translate([0,0,grid_wall_thick])linear_extrude(height=ep)minkowski()
        {
            center_tri(wall);
            circle(r=bevel,$fn=40);
        }
        //mid 2
        translate([0,0,grid_wall_thick-ep-bevel])linear_extrude(height=ep)center_tri(wall);
    }
    linear_extrude(height=grid_wall_thick)center_tri(wall);
    hull()
    {
        //mid 1
        translate([0,0,bevel])linear_extrude(height=ep)center_tri(wall);
        //bottom
        translate([0,0,-ep])linear_extrude(height=ep)minkowski()
        {
            center_tri(wall);
            circle(r=bevel,$fn=40);
        }
    }
}
module down_vol(wall)
{
    //center triangle
    hull()
    {
        //top
        translate([0,0,grid_wall_thick])linear_extrude(height=ep)minkowski()
        {
            down_tri(wall);
            circle(r=bevel,$fn=40);
        }
        //mid 2
        translate([0,0,grid_wall_thick-ep-bevel])linear_extrude(height=ep)down_tri(wall);
    }
    linear_extrude(height=grid_wall_thick)down_tri(wall);
    hull()
    {
        //mid 1
        translate([0,0,bevel])linear_extrude(height=ep)down_tri(wall);
        //bottom
        translate([0,0,-ep])linear_extrude(height=ep)minkowski()
        {
            down_tri(wall);
            circle(r=bevel,$fn=40);
        }
    }
}
module left_down_vol(wall)
{
    hull()
    {
        translate([0,0,grid_wall_thick])linear_extrude(height=ep)minkowski()
        {
            d_left_tri(wall);
            circle(r=bevel,$fn=40);
        }
        translate([0,0,grid_wall_thick-ep-bevel])linear_extrude(height=ep)d_left_tri(wall);
    }
    linear_extrude(height=grid_wall_thick)d_left_tri(wall);
    hull()
    {
        translate([0,0,bevel])linear_extrude(height=ep)d_left_tri(wall);
        
        translate([0,0,-ep])linear_extrude(height=ep)minkowski()
        {
            d_left_tri(wall);
            circle(r=bevel,$fn=40);
        }
    }
}
module right_down_vol(wall)
{
    hull()
    {
        translate([0,0,grid_wall_thick])linear_extrude(height=ep)minkowski()
        {
            d_right_tri(wall);
            circle(r=bevel,$fn=40);
        }
        translate([0,0,grid_wall_thick-ep-bevel])linear_extrude(height=ep)d_right_tri(wall);
    }
    linear_extrude(height=grid_wall_thick)d_right_tri(wall);
    hull()
    {
        translate([0,0,bevel])linear_extrude(height=ep)d_right_tri(wall);
        
        translate([0,0,-ep])linear_extrude(height=ep)minkowski()
        {
            d_right_tri(wall);
            circle(r=bevel,$fn=40);
        }
    }
}
module left_up_vol(wall)
{
    hull()
    {
        translate([0,0,grid_wall_thick])linear_extrude(height=ep)minkowski()
        {
            u_left_tri(wall);
            circle(r=bevel,$fn=40);
        }
        translate([0,0,grid_wall_thick-ep-bevel])linear_extrude(height=ep)u_left_tri(wall);
    }
    linear_extrude(height=grid_wall_thick)u_left_tri(wall);
    hull()
    {
        translate([0,0,bevel])linear_extrude(height=ep)u_left_tri(wall);
        
        translate([0,0,-ep])linear_extrude(height=ep)minkowski()
        {
            u_left_tri(wall);
            circle(r=bevel,$fn=40);
        }
    }
}
module right_up_vol(wall)
{
    hull()
    {
        translate([0,0,grid_wall_thick])linear_extrude(height=ep)minkowski()
        {
            u_right_tri(wall);
            circle(r=bevel,$fn=40);
        }
        translate([0,0,grid_wall_thick-ep-bevel])linear_extrude(height=ep)u_right_tri(wall);
    }
    linear_extrude(height=grid_wall_thick)u_right_tri(wall);
    hull()
    {
        translate([0,0,bevel])linear_extrude(height=ep)u_right_tri(wall);
        
        translate([0,0,-ep])linear_extrude(height=ep)minkowski()
        {
            u_right_tri(wall);
            circle(r=bevel,$fn=40);
        }
    }
}
module center_tri(wall)
{
    polygon(points=
    [[0,th0-(wall/2/sin(tip_angle/2))],
    [-((tw0/2)-wall/2/tan(base_angle/2)),wall/2],
    [((tw0/2)-wall/2/tan(base_angle/2)),wall/2]]);
}
module down_tri(wall)
{
    polygon(points=
    [[0,(wall/2/sin(tip_angle/2))],
    [-((tw0/2)-wall/2/tan(base_angle/2)),th0-(wall/2)],
    [((tw0/2)-wall/2/tan(base_angle/2)),th0-(wall/2)]]);
}
module u_left_tri(wall)
{
    polygon(points=
    [[-(tw0/2-wall/2),wall/2],
    [-(wall/2/tan(base_angle/2)),wall/2],
    [-(tw0/2-wall/2),th0-(wall/2/tan(tip_angle/4))]]);
}
module u_right_tri(wall)
{
    polygon(points=
    [[(tw0/2-wall/2),wall/2],
    [(wall/2/tan(base_angle/2)),wall/2],
    [(tw0/2-wall/2),th0-(wall/2/tan(tip_angle/4))]]);
}
module d_left_tri(wall)
{
    polygon(points=[[-(tw0/2-wall/2),th0-wall/2],
    [-(wall/2/tan(base_angle/2)),th0-wall/2],
    [-(tw0/2-wall/2),(wall/2/tan(tip_angle/4))]]);
}
module d_right_tri(wall)
{
    polygon(points=[[(tw0/2-wall/2),th0-wall/2],
    [(wall/2/tan(base_angle/2)),th0-wall/2],
    [(tw0/2-wall/2),(wall/2/tan(tip_angle/4))]]);
}