//origin is laser centre
s1=2.7;

square1_p=[-3.5,-13-1.76+10];
square1_s=[11,32+1.76-10];

laser=5/2;
laser2=[1.1,5/2+1/2,180+45];
laser_s=50;

track_w=10;
track_p=[5+4.5,15-2];

//lights_s=[2,14];
//lights_p=[-1,12];

hole1=3/2;
hole1_s=30;
hole1_p=[0,10];

//hole2=3/2;
//hole2_s=30;
//hole2_p=[0,-10];





use <../tools/snaps.scad>;


difference(){
	union(){
		translate(square1_p) square(square1_s);
		translate(track_p) Snap1B(width=track_w);
	}
	circle(laser,$fn=laser_s);
    
//	translate(lights_p) square(lights_s);
	translate(hole1_p) circle(hole1,$fn=hole1_s);
//	translate(hole2_p) circle(hole2,$fn=hole2_s);
}
rotate(laser2[2]) translate([0,laser2[1]]) circle(laser2[0],$fn=laser_s);