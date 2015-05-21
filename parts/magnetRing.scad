sheet3=2.95;
sheet=sheet3;

magnet=4.3/2;
nail=1.8/2;

magnetHold=.35;

wall=1.8;
IR=9.45;
OR=IR+wall;

gap=5/2+1;
flex=1.5+.5;


holders=false;



difference(){
	union(){
		translate([0,sheet/2]) ring(IR,OR);

		translate([-magnet-flex,gap+magnet]) square([magnet*2+flex*2,max(0,IR-gap-magnet+sheet/2)]);
		translate([0,gap+magnet]) circle(magnet+flex,$fn=30);
		
		mirror([0,1,0]){
			translate([-magnet-flex,gap+magnet]) square([magnet*2+flex*2,max(0,IR-gap-magnet-sheet/2)]);
			translate([0,gap+magnet]) circle(magnet+flex,$fn=30);
			//translate([0,gap+magnet*2+nail]) circle(magnet+flex,$fn=30);
			translate([0,gap+magnet+magnet+nail+.3]) circle(nail+0.5,$fn=30);
		}
	}

	translate([0,gap+magnet]) circle(magnet,$fn=30);
	translate([0,gap+magnet+magnet+nail+.3]) circle(nail,$fn=30);
	square([gap*2+flex*2,gap*2],center=true);

	mirror([0,1,0]){
		translate([0,gap+magnet]) circle(magnet,$fn=30);
		translate([0,gap+magnet+magnet+nail+.3]) circle(nail,$fn=30);
		square([gap*2+flex*2,gap*2],center=true);
	}
}

difference(){
		union(){
			
			translate([-OR,-OR+sheet/2-1.3])square([OR*2,OR+1]);
		}
		translate([0,sheet/2]) circle(OR-.1);
		translate([0,-(gap+magnet+magnet+nail+.3)]) circle(nail,$fn=30);
}






if(holders==true) holders();


module ring(r1,r2){
	difference(){
		union(){
			circle(r2,$fn=r2*8);
		}
		circle(r1,$fn=r2*8);
	}
}

module holder(){
	translate([-IR,sheet/2]) square(2);
}

module holders(){
	holder();
	mirror([1,0,0]) holder();
	mirror([0,1,0]) holder();
	mirror([1,0,0]) mirror([0,1,0]) holder();
}