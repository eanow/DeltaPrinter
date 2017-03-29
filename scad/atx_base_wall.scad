include <config.scad>;
include <base_config.scad>;

base_ext_l=331;

fit_tolerance=.5; //added gap between elements

bracket_wall=3.2;

truss_wall=2.39;

bevel=.5;

//edge to (upper) hole
euh=(base_ext_l-atx_upper_screw_spacing)/2;
//additional added to left side edge, to cover area around mount
mount_overlap=5;
//center of hole to edge of screw recess, and edge total overlap
eto=atx_screw_head/2+mount_overlap;
plate_round=2;
//plate height
ph=vertical_buffer+atx_height-fit_tolerance*2; //tolerance gap top and bottom

//ATX box needs a little bit of recess
atx_recess=grid_wall_thick-(atx_screw_depth+atx_screw_head_t);

translate([.5*(eto+euh-fit_tolerance)+fit_tolerance-base_ext_l/2,0,0])
{
    difference()
    {
        union()
        {
            rough_shape();
            slope();
        }
        atx_cutout();
        truss_grid(truss_wall);
        mirror([0,1,0])truss_grid(truss_wall);
        m3_holes();
        atx_holes();
        m4_hole();
    }
    
    difference()
    {
        m4_mount();
        m4_hole();
    }
}

//slope
module slope()
{
    intersection()
    {
        hull()
        {
            translate([20/2-(eto+euh-fit_tolerance)/2+euh-(atx_width-atx_upper_screw_spacing)/2-fit_tolerance*1.5-bracket_wall,0,.5])cube([20,ph+5,1],center=true);
            translate([20/2-(eto+euh-fit_tolerance)/2+euh-(atx_width-atx_upper_screw_spacing)/2-fit_tolerance*1.5-bracket_wall,-ph/2,-atx_depth/3])cube([20,1,1],center=true);
        }
        translate([0,0,-atx_depth/2])linear_extrude(height=atx_depth)rough_outline(plate_round);
    }
}

//m3 holes
module m3_holes()
{
    for(aa=[-.5:1:.5])
    {
    translate([-(eto+euh-fit_tolerance)/2-fit_tolerance+wall_screw_horz,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep])cylinder(r=m3_slot/2,h=grid_wall_thick+ep*2);
        translate([-(eto+euh-fit_tolerance)/2-fit_tolerance+wall_screw_horz,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep+grid_wall_thick-m3nut_t])cylinder(r=m3_head_r,h=m3nut_t*2);
        translate([-(eto+euh-fit_tolerance)/2-fit_tolerance+wall_screw_horz,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep+grid_wall_thick-m3nut_t-1])cylinder(r2=m3_head_r,r1=m3_slot/2,h=1+ep);
    }
}
//atx holes
//m3 holes
module atx_holes()
{
    for(aa=[-.5:1:.5])
    {
    translate([-(eto+euh-fit_tolerance)/2-fit_tolerance+euh,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep])cylinder(r=atx_screw_slot/2,h=grid_wall_thick+ep*2);
        translate([-(eto+euh-fit_tolerance)/2-fit_tolerance+euh,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep+grid_wall_thick-m3nut_t])cylinder(r=atx_screw_head/2,h=m3nut_t*2);
        translate([-(eto+euh-fit_tolerance)/2-fit_tolerance+euh,aa*(vertical_buffer+atx_height-wall_screw_vert*2),-ep+grid_wall_thick-m3nut_t-1])cylinder(r2=atx_screw_head/2,r1=atx_screw_slot/2,h=1+ep);
    }
}

//m4 mount hole, for connection to frame
module m4_mount()
{
    translate([-(eto+euh-fit_tolerance)/2-fit_tolerance+wall_screw_horz+1.5*m3_slot+linear_x/2,ph/2-(m4_nut_r+2.0),0])
    {
        cylinder(r1=m4_nut_r+2-bevel,r2=m4_nut_r+2,h=bevel);
        translate([0,0,bevel])cylinder(r=m4_nut_r+2,h=grid_wall_thick-bevel*2);
        translate([0,0,grid_wall_thick-bevel])cylinder(r2=m4_nut_r+2-bevel,r1=m4_nut_r+2,h=bevel);
    }
}
module m4_hole()
{
    translate([-(eto+euh-fit_tolerance)/2-fit_tolerance+wall_screw_horz+1.5*m3_slot+linear_x/2,ph/2-(m4_nut_r+2.0),-ep])
    {
        cylinder(r=m4_slot/2,h=grid_wall_thick+ep*2);
        cylinder(r=m4_nut_r,h=m3nut_t,$fn=6);
    }
}


module rough_outline(pr)
{
    //rough rectangle, one tolerance at edge by post
    minkowski()
    {
        square([eto+euh-fit_tolerance-plate_round*2,ph-plate_round*2],center=true);
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
module atx_cutout()
{
    //align such that 3mm 'shelf' at the bottom
    yy=-(ph/2)+(atx_height+fit_tolerance)/2+3;
    //alight so that atx ends up in middle
    xx=-(eto+euh-fit_tolerance)/2+-fit_tolerance+base_ext_l/2;
    //align for screw depth
    zz=-(atx_depth/2)+atx_recess;
    translate([xx,yy,zz])cube([atx_width+fit_tolerance,atx_height+fit_tolerance,atx_depth],center=true);
}

    //space occupied
    //distance between screw hole on post, and wall on atx bracket
    linear_x=(base_ext_l-atx_width)/2-wall_screw_horz-bracket_wall-1.5*m3_slot;
    //we will arrange two rows of triangles
    triangle_height_0=ph/2-truss_wall/2;
    //assuming equilateral triangles,
    ideal_width=2*triangle_height_0/sqrt(3);
    //how many triangles?
    triangle_num=1;//round(linear_x/ideal_width);
    //width of triangles
    triangle_width_0=linear_x/triangle_num;
    th0=triangle_height_0;
    tw0=triangle_width_0;
    te0=sqrt(th0*th0+(tw0/2*tw0/2));
    base_angle=acos((tw0/2)/te0);
    tip_angle=180-(base_angle*2);

module truss_grid(wall)
{
    translate([-(eto+euh-fit_tolerance)/2-fit_tolerance+wall_screw_horz+1.5*m3_slot+linear_x/2,0,0])
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
        //left triangle
        hull()
        {
            translate([0,0,grid_wall_thick])linear_extrude(height=ep)minkowski()
            {
                left_tri(wall);
                circle(r=bevel,$fn=40);
            }
            translate([0,0,grid_wall_thick-ep-bevel])linear_extrude(height=ep)left_tri(wall);
        }
        linear_extrude(height=grid_wall_thick)left_tri(wall);
        hull()
        {
            translate([0,0,bevel])linear_extrude(height=ep)left_tri(wall);
            
            translate([0,0,-ep])linear_extrude(height=ep)minkowski()
            {
                left_tri(wall);
                circle(r=bevel,$fn=40);
            }
        }

        //left triangle
        hull()
        {
            translate([0,0,grid_wall_thick])linear_extrude(height=ep)minkowski()
            {
                right_tri(wall);
                circle(r=bevel,$fn=40);
            }
            translate([0,0,grid_wall_thick-ep-bevel])linear_extrude(height=ep)right_tri(wall);
        }
        linear_extrude(height=grid_wall_thick)right_tri(wall);
        hull()
        {
            translate([0,0,bevel])linear_extrude(height=ep)right_tri(wall);
            
            translate([0,0,-ep])linear_extrude(height=ep)minkowski()
            {
                right_tri(wall);
                circle(r=bevel,$fn=40);
            }
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
module left_tri(wall)
{
    polygon(points=[[-(tw0/2-wall/2),th0-wall/2],
    [-(wall/2/tan(base_angle/2)),th0-wall/2],
    [-(tw0/2-wall/2),(wall/2/tan(tip_angle/4))]]);
}
module right_tri(wall)
{
    polygon(points=[[(tw0/2-wall/2),th0-wall/2],
    [(wall/2/tan(base_angle/2)),th0-wall/2],
    [(tw0/2-wall/2),(wall/2/tan(tip_angle/4))]]);
}