length=46+1.7+1;  			//total length
width=1.5+.7;  			//edge thickness
rod_radius=3.2/2+.1;		//dampening aluminium
rod_length=9-.4;
magnet_radius=.5;		//tiny magnet marking
thread_hole=.5;		//triangle "radius"
mirror_x=5;		//mirror size
mirror_y=10;
rod_to_magnet=15-.3;		

//bottom to top
//thread hole and //magnet mark:
translate([-thread_hole,0]){
	difference(){
        union(){
            translate([(width+thread_hole*2)/2, width/2+thread_hole]) circle(width*1/2+thread_hole,$fn=20);
            translate([0, width/2+thread_hole]) square([width+thread_hole*2,magnet_radius+thread_hole+width/4]);
            translate([width/2+magnet_radius,magnet_radius+width/2+thread_hole*2+width/4]) circle(width*1/2+thread_hole,$fn=40);
        }
		translate([(width+thread_hole*2)/2, width/2+thread_hole]) rotate(30) circle(thread_hole+.2, $fn=3);
		translate([width/2+magnet_radius,magnet_radius+width/2+thread_hole*2+width/4]) circle(magnet_radius,$fn=15);
	}
}




//body:
translate([0,width+thread_hole*2+magnet_radius*2]) square([width,rod_to_magnet-rod_length*11/16]);

//burr hole
burr=.5;
//triangle
tri=.5;
//aluminum:
translate([-rod_radius,width+thread_hole*2+magnet_radius*2+rod_to_magnet-rod_length*11/16]){
	difference(){
        union(){
            translate([0,-burr])square([width+rod_radius*2,width+rod_length+burr*2]);
        }
		translate([width/2,width/2]) square([rod_radius*2,rod_length]);
        //burr hole
        translate([width/2,width/2-burr]) square(burr);
        translate([width/2+rod_radius*2-burr,width/2-burr]) square(burr);
        translate([width/2,width/2+rod_length]) square(burr);
        translate([width/2+rod_radius*2-burr,width/2+rod_length]) square(burr);
	}
    translate([width/2+burr,width/2])polygon([[0,0],[rod_radius*2-burr*2,0],[rod_radius-burr,tri]]);
    translate([width/2+burr,width/2+rod_length])polygon([[0,0],[rod_radius*2-burr*2,0],[rod_radius-burr,-tri]]);
}

//body:
translate([0,width*2+thread_hole*2+magnet_radius*2+rod_to_magnet+rod_length-rod_length*11/16]) square([width,length-(mirror_y+thread_hole*2+width*3/4)-(width*2+thread_hole*2+magnet_radius*2+rod_to_magnet+rod_length)+rod_length*12/16]);

//mirror:
translate([width/2-mirror_x/2,length-(mirror_y+thread_hole*2+width*3/4)]){
square([mirror_x,mirror_y]);
}

//thread hole:
translate([-thread_hole, length-thread_hole*2-width*3/4]){
	difference(){
        union(){
            translate([width/2+thread_hole,width/2]) circle(width*1/2+thread_hole,$fn=20);
            translate([width/2-width*1/2,0]) square([width+thread_hole*2,width*1/3+thread_hole]);
        }
		translate([width/2+thread_hole,width/4+thread_hole]) rotate(-30) circle(thread_hole+.2, $fn=3);
	}
}