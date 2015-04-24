
//-----------Notes:--------------

/*(following is from description txt file. see it for more complete description of each part and function)
Parts: 
 
Base
	-holds laser mounts, snap them into [some] distance to mirror A, [some] distance outward is mirror A
	-holds mirror A frame, snaps. Mirror A is between snap circles, [some] distance outward.
	-holds mirror B mount, slot for snap. Mirror A is at bottom of slot, mirrors are [some] distance away from slot
	-holes for standoffs
Laser mounts
	-lines up laser in 2 directions with mirror A from close corner of slot

Mirror B mount
	-holds mirror B frame, snaps. mirrors height is [some] distance from bottom, mirror B left-right is [some] distance from bottom left (mirror a)

Mirror A frame
	-notches for snapping to base
	-mark squares [some] distance to mirror, static magnet holder
	-mark lines [some] distance to rod ends, dampener

Mirror B frame
	-all parts of mirror A frame
	-knobs on mirror end
*/



	//--------------Variables:------------------


//note on variables: 	mirror locations refer to center of mirror
//						laser locations in Y and Z direction are to center of laser
//				 		other distances are to nearest edge

//measured variables:
//(3mm)  :
laserCutWidth=.16;				//thickness of plastic removed when cutting (diameter rather than radius)
//acetate:
//laserCutWidth=.7;

sheet=2.96;						//thickness of sheet
sheet_A=sheet-laserCutWidth;	//corrected for laser cut

hoseThickness=3;				//extra room the hose takes up 
hoseTight=1.75;					//gap when it is tight

LaserLength=50;					
LaserRadius=6.5;
mirrorThick=.7;		//thickness of mirrors

	//controlled variables:
	freeThread=5;		//length of thread free to rotate/stretch on each side (between mirrors/magnets and frame)

	mirrorWidth=5;		//mirrors dimensions: 	
	mirrorLength=10;	//						(both mirrors are mirrorWidth by mirrorLength)

	threadhookThin=0;		//thinner part of threadhook
	threadhookThick=1.2;	//thicker part of threadhook


	frameThick=3.5;		   			//strength of frame

	frameInsideWidth=13;					//inside width of frame
	frameKnob=threadhookThick*1.5;	//spacer to allow threadhook movement when attaching B frame to laser mount

	mirrorBHolderWidth=3;			//strength on a weak part of the mirror B holder

	TrackWidth_A=15;				//laser track wide
	TrackWidth_B=10;				//laser track narrow
	perimeterSlot=3.5;			//width of plastic on edges of slots
	dampenerToBase_Z=10;				//distance from dynamic dampener to the base in Z direction

	


		//alignment variables:
		mirrorsToBase_Z=max(mirrorLength/2,sin(45)*(frameInsideWidth/2+frameThick+sheet_A+threadhookThin+mirrorThick)+mirrorBHolderWidth);
										//distance from mirrors to the base in z direction
		mirrorAToLaserTrack_Y=sin(45)*(frameThick+frameInsideWidth/2+sheet_A+laserCutWidth)+sin(45)*(threadhookThin+mirrorThick);
										//distance from mirror A to the wider part of the laser track

		mirrorAToB=mirrorWidth*1.2;		//distance between the two mirrors (Y direction)

		mirrorsToBHolder_X=sin(45)*(threadhookThin+mirrorThick+frameThick+frameInsideWidth/2+sheet_A+laserCutWidth)+perimeterSlot;
										//distance from mirrors to b frame holder in x direction

		LaserToMirrorBHolder_X=max((frameInsideWidth+frameThick*2+sheet_A*2)*sin(45)+hoseThickness+perimeterSlot,mirrorsToBHolder_X+mirrorLength/2+freeThread+frameThick+frameKnob)+3.5;
										//distance from the laser to the Mirror B Holder
//End of Variables


//--------------------Laser mount snaps:---------------------------

//parameters:
//	ridge_X
//		-width of ridge that stops laser from going left
//	ridge_Y
//		-depth of ridge that stops laser from going left
//	notch
//		-notch on top that holds laser mount in place
//	curve
//		-radius of arc
//	arc
//		-degrees of the circle from the tightest point to the resting point when snapped
//	edges
//		-edges on 360 degrees of the circle
//	length
//		-length of the track taken up by this module
//	width
//		-width of the track
//	cut
//		-width of the cut
//	thick
//		-width of the bending part
//	extraTension
//		-tension after the mount is snapped in

module laserSnap(ridge_X=2, ridge_Y=1, notch=1.2, curve=2.5, arc=40, edges=45, length=22, width=10, cut=1.5, thick=2.9, extraTension=0.4){		
	//laser mounts snap into this
	//zero x coord is left edge of mount

	//add ridge to stop mount from going further left
	translate([-ridge_X,-ridge_Y])
		square([ridge_X,ridge_Y]);

	difference(){
		union(){ 
			//main block
			square([length,width]);
			//add curve
				translate([sheet_A+curve*sin(arc),curve*cos(arc)-extraTension])
				circle(curve, $fn=edges);
			//(when snapped in) extra tension
				translate([cut,-extraTension])
					square([sheet_A-cut,extraTension]);
		}
		//cut out
		square([cut,thick]);
		translate([0,thick])
			square([length-thick*1.5,cut]);


	}
//notch on top
		translate([-notch,width])
			square([notch+.000505,notch/2]);
		translate([sheet_A,width])
			square([notch+.000505,notch/2]);
}

//----------------Laser track:-------------------


module laserTrack(){
	//top-right section of the base
	//two laser mounts snap onto this, one is thinner to allow the other past.
	
	//the distance to first mount lets the B frame attach to the first mount
	//the distance between mounts allows the laser to fit between tightly
	

	//there are two slots for standoffs to connect the base to the case

	difference() {
		union(){
			//block to first mount:
			translate([0,-laserCutWidth/2])
			square([LaserToMirrorBHolder_X,TrackWidth_A+laserCutWidth]);
			//snap for first mount:
			translate([LaserToMirrorBHolder_X,-laserCutWidth/2])
				laserSnap(width=TrackWidth_A+laserCutWidth, length=23);
			//block to second mount:
			translate([LaserToMirrorBHolder_X+23,-laserCutWidth/2])
				square([LaserLength*3/4-23-15,TrackWidth_A+laserCutWidth]);
			//snap for second mount:
			translate([LaserToMirrorBHolder_X+LaserLength*3/4,TrackWidth_A/2-TrackWidth_B/2])
				rotate(90)
					pushSnap(length=15,stopWidth=TrackWidth_A+laserCutWidth,cut=.5,cutLength=12);
		}
	//standoff slots:
	translate([LaserToMirrorBHolder_X-6,-laserCutWidth/2+perimeterSlot])
		square([sheet_A,TrackWidth_A- perimeterSlot*2+.075]);
	translate([LaserToMirrorBHolder_X+21,-laserCutWidth/2+perimeterSlot])
		square([sheet_A,TrackWidth_A- perimeterSlot*2+.075]);
	}

}


//-----------Slots for Mirror A:------------


	module MirrorASlots(){
		translate([0,3]){
		difference(){
		
			translate([-sheet_A-hoseTight*2+hoseTight+sheet_A/2,perimeterSlot+sheet_A+threadhookThin+mirrorThick])
				square([sheet_A+hoseTight,frameInsideWidth]);
			translate([-sheet_A-hoseTight*2+hoseTight+sheet_A/2,perimeterSlot+sheet_A+threadhookThin+mirrorThick])
				square([hoseTight,1]);
			translate([-sheet_A-hoseTight*2+hoseTight+sheet_A/2,perimeterSlot+sheet_A+frameInsideWidth-.5+threadhookThin+mirrorThick-.5])
				square([hoseTight,1]);
		}
		}

}

//-----------Slots for Mirror B:------------


	module MirrorBSlots(){

	//frame holder slot:	
	difference(){
		//perimeter:
		translate([-sheet_A-perimeterSlot,-mirrorAToB*2-perimeterSlot- mirrorAToLaserTrack_Y])
			square([sheet_A+ perimeterSlot*2,mirrorAToB*2+ perimeterSlot*2+ mirrorAToLaserTrack_Y]);
		//slot:
		//(length of the slot is twice the distance between mirrors, with mirror B (y coord) in the center of the slot)
		translate([-sheet_A,-mirrorAToB*2+laserCutWidth/2- mirrorAToLaserTrack_Y-1])
			square([sheet_A+.02,mirrorAToB*2-laserCutWidth]);
	}
	//fill in above slot
	translate([-sheet_A-perimeterSlot,- mirrorAToLaserTrack_Y])
		square([sheet_A+perimeterSlot,TrackWidth_A+ mirrorAToLaserTrack_Y]);



	//dampener slot:
/*	difference() {
		translate([-sheet_A*2- hoseTight*2-perimeterSlot*3,- mirrorAToLaserTrack_Y-mirrorAToB- frameInsideWidth- perimeterSlot])
			square([sheet_A+perimeterSlot*2+hoseTight*2,frameInsideWidth+perimeterSlot*2]);
		translate([-sheet_A*2-hoseTight*2-perimeterSlot*2,- mirrorAToLaserTrack_Y-mirrorAToB- frameInsideWidth])
			square([sheet_A+hoseTight,frameInsideWidth]);


	}
	//hose clamp markers:
			translate([-sheet_A*2-hoseTight*2-perimeterSlot*2,- mirrorAToLaserTrack_Y-mirrorAToB- frameInsideWidth])
				square([hoseTight,.5]);
			translate([-sheet_A*2-hoseTight*2-perimeterSlot*2,- mirrorAToLaserTrack_Y-mirrorAToB- frameInsideWidth+frameInsideWidth-.5])
				square([hoseTight,.5]);
*/
}



//---------------Snap for mirror frames:------------

//parameters:
//	curve
//		-radius of arc
//	arc
//		-degrees of the arc from tightest point to resting point after snapped
//	edges
//		-edges on 360 degrees of the circle
//	extraTension
//		-tension after it is snapped in

module FrameSnap(curve=3, arc=45, edges=30, extraTension=.2){


	difference() {
			rotate(-45)
				//move from mirror surface to where the frame rests
				translate([0,-sheet_A- threadhookThin- mirrorThick])
					{

						//back rest
						translate([-frameInsideWidth/2- frameThick+ laserCutWidth/2-perimeterSlot+ extraTension,-frameInsideWidth*1.4])
							square([frameInsideWidth+frameThick*2-laserCutWidth+perimeterSlot*2- extraTension*2,frameInsideWidth*1.4]);


						//left edge and curve:
						
						translate([-frameInsideWidth/2- laserCutWidth/2+curve*cos(arc),sheet_A+curve*sin(arc)-extraTension])
							circle(curve, $fn=edges);

						//right edge and curve:
						
						translate([+frameInsideWidth/2+ laserCutWidth/2-curve*cos(arc),sheet_A+curve*sin(arc)-extraTension])
							circle(curve, $fn=edges);						
						
												//connect between:
						translate([-frameInsideWidth/2-laserCutWidth/2,0])
							square([frameInsideWidth+laserCutWidth,sheet_A-extraTension]);
					}
		//cut edges:
		translate([-frameInsideWidth-sin(45)*(frameInsideWidth/2+frameThick+perimeterSlot+sheet_A+threadhookThin+mirrorThick),-frameInsideWidth*2-sin(45)*(frameInsideWidth/2+frameThick+perimeterSlot+sheet_A)])
			square([frameInsideWidth,frameInsideWidth*4]);
		translate([-sin(45)*(frameInsideWidth/2+frameThick+perimeterSlot+sheet_A+threadhookThin+mirrorThick),-frameInsideWidth*2-sin(45)*(frameInsideWidth/2+frameThick+perimeterSlot+sheet_A+threadhookThin+mirrorThick)])
		square(frameInsideWidth*2);

		//room for thread assembly:
		circle(4,$fn=30);
		rotate(45) translate([0,-4])square([10,8]);
	}

}

//----------------Laser Mount A----------------

//parameters:
//	perimeter
//		-thickness around slot and laser hole
module LaserMountA(perimeter=5) {
	difference() {
		union(){
			translate([mirrorAToLaserTrack_Y,-mirrorsToBase_Z]){
				difference() {
					translate([-mirrorAToLaserTrack_Y,-sheet_A-perimeter])
						square([mirrorAToLaserTrack_Y+TrackWidth_A+perimeter,sheet_A+perimeter+mirrorsToBase_Z]);
					translate([+laserCutWidth/2,-sheet_A])
						square([TrackWidth_A-laserCutWidth,sheet_A]);
				}

			}
			circle(LaserRadius+hoseTight+perimeter);
		}
		circle(LaserRadius+hoseTight);
		translate([-LaserRadius-hoseTight-perimeter,-LaserRadius-hoseTight-perimeter])
			square([LaserRadius+hoseTight+perimeter,hoseTight+perimeter]);
		rotate(20)
			translate([-LaserRadius-hoseTight-perimeter,-hoseTight-perimeter])
			square([LaserRadius+hoseTight+perimeter,hoseTight+perimeter]);
	}


}


//----------------Laser Mount B----------------





//parameters:
//	perimeter
//		-thickness around slot and laser hole
module LaserMountB(perimeter=3) {
	difference() {
		union(){
			translate([mirrorAToLaserTrack_Y+(TrackWidth_A- TrackWidth_B)/2,-mirrorsToBase_Z]){
				difference() {
					translate([-mirrorAToLaserTrack_Y-(TrackWidth_A- TrackWidth_B)/2,-sheet_A-perimeter])
						square([mirrorAToLaserTrack_Y-(TrackWidth_A- TrackWidth_B)/2+TrackWidth_A+perimeter,sheet_A+perimeter+mirrorsToBase_Z]);
					translate([+laserCutWidth/2,-sheet_A])
						square([TrackWidth_B-laserCutWidth,sheet_A]);
				}

			}
			circle(LaserRadius+perimeter);
		}
		circle(LaserRadius+.2);

	}


}
LaserMountB();
//--------------B frame holder:------------------
//parameters:
//	curve
//		-radius of arc
//	arc
//		-degrees of the arc from tightest point to resting point after snapped
//	edges
//		-edges on 360 degrees of the circle
//	cut
//		-width of the cut for bending
//	thick
//		-width of the bending part
//	extraTension
//		-tension after it is snapped in
//	cutLength
//		-length of the cut for bending

//simplifying variable:
fillGap=max(0,mirrorsToBase_Z-sin(45)*(frameInsideWidth/2+frameThick+sheet_A+threadhookThin+mirrorThick));


module BFrameHolder(curve=3, arc=36, edges=40, cut=0.2, cutLength=9.4, thick=2.7, extraTension=0.3){

	difference() {
		union(){
			translate([0,mirrorsToBase_Z]) rotate(45+90) translate([-3,7])
			square([8,21]);
			translate([0,mirrorsToBase_Z])
				{
				FrameSnap();
				}

			//left bend and curve:
			translate([-mirrorAToB-extraTension,-sheet_A])
				square([thick,sheet_A]);
			translate([-mirrorAToB+curve*cos(arc)-extraTension,-sheet_A-curve*sin(arc)+extraTension])
				circle(curve, $fn=edges);

			//right bend and curve:
			translate([mirrorAToB-thick+extraTension,-sheet_A])
				square([thick,sheet_A]);
			translate([mirrorAToB-curve*cos(arc)+extraTension,-sheet_A-curve*sin(arc)+extraTension])
				circle(curve, $fn=edges);


			//fill in gap between frame snap and bottom:
			//if(mirrorsToBase_Z>(sin(45)*(frameInsideWidth/2+frameThick+sheet_A+threadhookThin+mirrorThick)+mirrorBHolderWidth)){
				translate([-sin(45)*(frameInsideWidth/2+frameThick+sheet_A+threadhookThin+mirrorThick+perimeterSlot),0])
				square([sin(45)*(frameInsideWidth+frameThick*2+sheet_A+threadhookThin+mirrorThick+perimeterSlot),fillGap]);
			//}
			//for marking "2"
			translate([-11.78,19.32])rotate(-45)translate([-3,-3.3]) square([4,8]);
			translate([-11.78,19.32])rotate(-45)translate([-3,-3.3]) square([9,3]);
		
		}
		//cuts

		translate([-mirrorAToB-cut/4-extraTension,0])
			square([cut/4,cutLength]);


		translate([-mirrorAToB+thick-extraTension,-sheet_A-curve*2])
			square([cut,+sheet_A+curve*2+cutLength-thick]);
translate([0,mirrorsToBase_Z]) rotate(45+90) translate([0,3]) mirror([1,0,0])
MirrorASlots();
	}		

}



//-------------- Frame:------------------------

magnetToBase_Z=dampenerToBase_Z+10;
frameLengthInside=freeThread*2+mirrorLength/2+mirrorsToBase_Z+sheet+magnetToBase_Z;

tighterSheet=.07;


module Frame(ridge_X=3,ridge_Y=1.5){
	//(counterclockwise starting at left middle)
	translate([0,-tighterSheet/2])
		square([ridge_Y*1.7+frameThick,ridge_X+tighterSheet/2]);
	translate([0,-sheet_A])
		square([frameThick,sheet_A]);
	translate([0,-sheet_A-ridge_X])
		square([frameThick+ridge_Y*1.7,ridge_X+tighterSheet/2]);
	
	//left to bottom:
	translate([0,-sheet-magnetToBase_Z- freeThread])
		square([frameThick,magnetToBase_Z+freeThread]);

	//bottom:
	difference() {
		translate([0,-sheet-magnetToBase_Z- freeThread- frameThick])
			square([frameThick*2+frameInsideWidth,frameThick]);

		//notches for thread
		translate([0,-sheet-magnetToBase_Z- freeThread-0.3])
			square([.6,0.01]);
		translate([frameInsideWidth+frameThick*2-.6,-sheet-magnetToBase_Z- freeThread-0.3])
			square([.6,0.01]);
		translate([frameThick+frameInsideWidth/2-0.005,-sheet-magnetToBase_Z- freeThread- frameThick])
			square([0.01,.6]);
	}
	
	//right:
	translate([frameThick+frameInsideWidth,-sheet-magnetToBase_Z- freeThread])
		square([frameThick,frameLengthInside]);

	//base ridges
	translate([frameThick+frameInsideWidth- ridge_Y*1.7,-tighterSheet/2])	
		square([ridge_Y*1.7,ridge_X+tighterSheet/2]);
	translate([frameThick+frameInsideWidth -ridge_Y*1.7,-sheet_A-ridge_X])
		square([ridge_Y*1.7,ridge_X+tighterSheet/2]);


	//top:
	difference() {
		union(){
			translate([0,mirrorsToBase_Z+mirrorLength/2+freeThread])
				square([frameInsideWidth+frameThick*2,frameThick]);
			translate([0,mirrorsToBase_Z+mirrorLength/2+freeThread -frameThick/2])
				square([frameThick, frameThick/2]);
		}
		//notches for thread
		translate([0,+.3+mirrorsToBase_Z+mirrorLength/2+freeThread])
			square([.6,0.01]);
		translate([frameInsideWidth+frameThick*2-.6,+.3+mirrorsToBase_Z+mirrorLength/2+freeThread])
			square([.6,0.01]);
		translate([frameThick+frameInsideWidth/2-0.005,mirrorsToBase_Z+mirrorLength/2+freeThread+frameThick-.6])
			square([0.01,.6]);
	}

	//magnet holder ridges
	//left
	translate([-ridge_Y,-sheet_A/2- magnetToBase_Z])
		square([ridge_Y,ridge_X+tighterSheet/2]);
	translate([-ridge_Y,-sheet_A*1.5- magnetToBase_Z- ridge_X])
		square([ridge_Y,ridge_X+tighterSheet/2]);
	//right
	translate([frameThick*2+frameInsideWidth,-sheet_A/2- magnetToBase_Z])
		square([ridge_Y,ridge_X+tighterSheet/2]);
	translate([frameThick*2+frameInsideWidth,-sheet_A*1.5- magnetToBase_Z- ridge_X])
		square([ridge_Y,ridge_X+tighterSheet/2]);
}

//---------------Push Snap:-------------------

//parameters:
//	curve
//		-radius of arc
//	arc
//		-degrees of the arc from tightest point to resting point after snapped
//	edges
//		-edges on 360 degrees of the circle
//	cut
//		-width of the cut for bending
//	thick
//		-width of the bending part
//	extraTension
//		-tension after it is snapped in
//	cutLength
//		-length of the cut for bending
//	width
//		-width of slot that it goes into
//	length
//		-length it takes up above snap point
//	stopwidth
//		-width after snap


module pushSnap(curve=2.5,arc=40,edges=40,cut=1,thick=3,extraTension=0.2,cutLength=5,width=TrackWidth_B,length=9,stopWidth=TrackWidth_A){
	difference(){
		union(){
			//left bend and curve:
			translate([-extraTension,-sheet_A])
				square([thick,sheet_A]);
			translate([+curve*cos(arc)-extraTension,-sheet_A-curve*sin(arc)+extraTension])
				circle(curve, $fn=edges);

			//right bend and curve:
			translate([width-thick+extraTension,-sheet_A])
				square([thick,sheet_A]);
			translate([width-curve*cos(arc)+extraTension,-sheet_A-curve*sin(arc)+extraTension])
				circle(curve, $fn=edges);

			//top
			translate([width/2-stopWidth/2,0])
			square([stopWidth,length]);
		}
		//cuts:
		translate([-cut/4-extraTension,0])
			square([cut/4,cutLength]);
		translate([+thick-extraTension,-sheet_A-curve*2])
			square([cut,+sheet_A+curve*2+cutLength-thick]);

	}
}





//-----------------Static Magnet Holder:---------------

module StaticMagnetHolder(magnetStatic=6.7,magnetDynamic=2.3,curve=1.8,edges=30,arc=37,extraTension=0.21,ridge_Y=2){
	difference(){
		//outside
		translate([-frameInsideWidth/2-frameThick-ridge_Y- perimeterSlot,-sheet_A-magnetStatic-perimeterSlot-magnetDynamic])
		union(){
			square([(frameInsideWidth/2+frameThick+ridge_Y+ perimeterSlot)*2,(sheet_A+magnetStatic+perimeterSlot)*2+magnetDynamic*2]);
			translate([frameInsideWidth/2+frameThick+ridge_Y+ perimeterSlot-5,-1]) 
			union(){
				square([10,1]);
				difference(){
					translate([-2,-1.5])square([14,1.5]);
					translate([-2,-.7])rotate(40) square(3);
					translate([-2+14,-.7])rotate(-40)translate([-3,0]) square(3);
				}
			}
		}
		//snapped slot
		translate([-frameInsideWidth/2-frameThick+ extraTension,0])
		square([frameInsideWidth+frameThick*2- extraTension*2,sheet_A+threadhookThin+mirrorThick]);

		//unsnapped slot
		translate([-frameInsideWidth/2-frameThick-ridge_Y,-magnetDynamic-sheet_A])
		square([frameInsideWidth+frameThick*2+ridge_Y*2,sheet_A+magnetDynamic]);

		//magnet holes
		translate([0,+threadhookThin+mirrorThick+magnetDynamic+sheet_A+magnetStatic/2])
		circle(magnetStatic/2,$fn=40);

		translate([0,-magnetDynamic-sheet_A-magnetStatic/2]){
			circle(magnetStatic/2,$fn=40);
			translate([-2,0]) square([4,magnetStatic/2]);
		}
		
	}
	//snap curves:
		difference(){
			union(){
				translate([-frameThick- frameInsideWidth/2- curve*cos(arc)+extraTension, threadhookThin+mirrorThick- curve*sin(arc)+extraTension])
					circle(curve, $fn=edges);
				translate([frameThick+ frameInsideWidth/2+ curve*cos(arc)-extraTension, threadhookThin+mirrorThick- curve*sin(arc)+extraTension])
					circle(curve, $fn=edges);	
			}
				translate([-frameInsideWidth/2-frameThick-ridge_Y,-magnetDynamic-sheet_A])
		square([frameInsideWidth+frameThick*2+ridge_Y*2,sheet_A]);
		}
}


//----------------Standoff:-------------------

module standoff(length=magnetToBase_Z+freeThread+frameThick+threadhookThick*3+20,extraTension=laserCutWidth/2-.05){
	//bottom
	translate([-extraTension,0])
		pushSnap(width=TrackWidth_A-perimeterSlot*2+extraTension*2,length=10,cutLength=9);

	//middle
	translate([-perimeterSlot,10])
		square([TrackWidth_A,length-20]);

	//top
	translate([TrackWidth_A-perimeterSlot*2+extraTension,length])
		rotate(180)
			pushSnap(width=TrackWidth_A-perimeterSlot*2+extraTension*2,length=10,cutLength=9);



}
//----------------circuit mount:-------------------

module circuit(length=magnetToBase_Z+freeThread+frameThick+threadhookThick*3+20,extraTension=laserCutWidth/2-.05){
	//bottom
	translate([-extraTension,0])
		pushSnap(width=TrackWidth_A-perimeterSlot*2+extraTension*2,length=10,cutLength=9);

	//middle
	translate([-perimeterSlot,10])
		square([TrackWidth_A,length-20]);

	//top
	translate([TrackWidth_A-perimeterSlot*2+extraTension,length])
		rotate(180)
			pushSnap(width=TrackWidth_A-perimeterSlot*2+extraTension*2,length=10,cutLength=9);
	
	circuitHoles(-36,0,extraTension){
			
	}

}
module circuitHoles(x,y,extraTension){
		translate([x,y]){
			difference(){
				square([58,47]);
				translate([-x-1,0]) square([TrackWidth_A-perimeterSlot*2+2+extraTension*2,100]);
				translate([4,4]) circle(1.5,$fn=15);
				translate([54,4]) circle(1.5,$fn=15);
				translate([54,43.5]) circle(1.5,$fn=15);
				translate([4,43.5]) circle(1.5,$fn=15);
			}	
		}

}


//----------------Static Dampeners:--------------
module staticDampenerA(){
	pushSnap(width=sheet_A+perimeterSlot,stopWidth=sheet_A+perimeterSlot*2,length=mirrorsToBase_Z,cutLength=8);
	//translate([-perimeterSlot/2,sheet_A+hoseThickness+mirrorsToBase_Z+4])
		//rotate(-45)	square(sheet_A+perimeterSlot*2);
}



module staticDampenerB(){
	difference() {
		translate([-perimeterSlot,-perimeterSlot])
			square([sheet_A+perimeterSlot*2,sheet_A*1.5+perimeterSlot*2]);
		translate([0,0])
			square([sheet_A,sheet_A+perimeterSlot]);
	}
	translate([-perimeterSlot,sheet_A+perimeterSlot])
		square([sheet_A+perimeterSlot*2,perimeterSlot+sheet_A+4.25]);
	//surface:
	difference(){
		translate([-perimeterSlot,sheet_A+perimeterSlot+perimeterSlot+sheet_A+3.5])
			square([sheet_A+perimeterSlot*2,4]);
		translate([+sheet_A/2,sheet_A+perimeterSlot+perimeterSlot+sheet_A+7.5])
			circle(3.25,$fn=15);
	}
}




//---------------Thread Assembly:----------------

//parameters:
//	hole
//		-hole for thread/rod at top and bottom
//	dampener radius
//	dampener length
//	perimeter(s)
//		-width around cutouts at different areas
// 	width
//		-width on narrow section
//	total length
//		- frame length less free thread
//	mirror grab
//		-the length that wraps around the mirror's face
//	tab depth
//		-makes folding easier
//	magnetFold
//		-length/width of fold for the magnet

module threadAssembly(hole=.5,dampenerRadius=1.4,dampenerLength=6,perimeterMagnet=1.8,perimeterDampener=1.0,width=2, totalLength=frameLengthInside -freeThread*2+1 ,mirrorGrab=01,tabDepth=1.5,magnetFold=2.5){
	
//mirror:	
	difference(){
		square([mirrorWidth,mirrorLength],center = true);

		//circle
		translate([0,mirrorLength/2 -hole -laserCutWidth])
			rotate(-30) circle(hole*1.5,$fn=3);

	}
	translate([-.35,5])square([.7,.4]);
	translate([-.8,5.4])square([1.6,.8]);
//dampener:

	difference() {
		translate([-dampenerRadius-perimeterDampener,mirrorLength/2 -totalLength+10]){
			square([dampenerRadius*2+perimeterDampener*2,dampenerLength]);	
			translate([+dampenerRadius+perimeterDampener,dampenerLength])
				circle(dampenerRadius+perimeterDampener,$fn=40);
			translate([0,-perimeterDampener])
				square([dampenerRadius*2+perimeterDampener*2,perimeterDampener]);
			
		}
		//folding piece:
		translate([-dampenerRadius,mirrorLength/2 -totalLength+10]){
			square([dampenerRadius*2,dampenerLength]);
		translate([dampenerRadius,dampenerLength])
			circle(dampenerRadius,$fn=20);
		}
	}


	//thin part:
		translate([-width/2,mirrorLength/2 -totalLength+magnetFold])
			square([width,10-magnetFold]);
		translate([-width/2,mirrorLength/2 -totalLength+10+dampenerLength+dampenerRadius])
			square([width,totalLength -mirrorLength -dampenerRadius -dampenerLength-10]);


	difference(){
		
		//at magnet:
		translate([-perimeterMagnet,mirrorLength/2 -totalLength -magnetFold/2 -hole*2 -laserCutWidth*2])
			square([perimeterMagnet*2,+magnetFold*1.5+hole*2+laserCutWidth*2]);
		translate([0,mirrorLength/2 -totalLength-magnetFold/2 -hole -laserCutWidth])
			rotate(30) circle(hole*1.5,$fn=3);
		translate([0,mirrorLength/2 -totalLength-magnetFold/2])
			square([magnetFold/2,magnetFold]);
	}
	translate([-.35,-40.15])square([.7,.4]);
	translate([-.8,-40.15-.8])square([1.6,.8]);

}
cardboard=4;
height=208+17;
front=171+8;
side=141.5;
overlap=15;
tinycut=0.006;

safeY=50+9;
safeX=25+6;
safeR=.3;

module cover(){
	%difference(){
		union(){
			translate([front+overlap*2,0]) square([front+side*2,height+side+overlap]);
		}
		square([front,side+overlap]);

		translate([front+overlap*2,0]) square([side,side+overlap]);
		translate([front+overlap*2,0]) square([tinycut,side+overlap+height]);

		translate([front+side+overlap*2,0]) square([front,side+overlap]);
		translate([front+side+overlap*2,0]) square([tinycut,side+overlap+height]);

		translate([front+side+front+overlap*2,0]) square([side,side+overlap]);
		translate([front+side+front+overlap*2,0]) square([tinycut,side+overlap+height]);
	}


	difference(){
		union(){
			square([front+overlap,height+side+overlap]);
			translate([-overlap,side+overlap+tinycut]) square([overlap-tinycut,height]);
			translate([0,height+side+overlap+0.006]) square([front,overlap]);

		}
		square([front,side+overlap]);

		translate([front,0]) square([side,side+overlap]);
		translate([front,0]) square([tinycut,side+overlap+height]);


		translate([0,side+overlap]) square([front,tinycut]);


	}
	difference(){
		union(){
			translate([-overlap,0]) square([front+overlap*2,side+overlap]);


		}
		translate([-overlap,0]) square(overlap);
		translate([front,0]) square(overlap);

		translate([front,side+overlap-.006]) square([overlap,0.006]);
		square([0.006,side+overlap]);
		translate([0,overlap]) square([front,0.006]);
		translate([front,overlap]) square([0.006,side]);


		translate([safeX,safeY+overlap]) circle(safeR,$fn=10);
		translate([front+side,side]) square([.006,overlap]);
		translate([front*2+side,side]) square([.006,overlap]);
		translate([front,side+overlap+height]) square([.006,overlap]);
	}


}


//----------------Call Modules:-----------------


threadAssembly();
 Frame();
square([5,10]);
cover();
union(){
LaserMountA();
translate([mirrorAToLaserTrack_Y+TrackWidth_A*2+LaserRadius,0])
	LaserMountB();
}
standoff();
circuit();
staticDampenerA();
staticDampenerB();
!StaticMagnetHolder();
BFrameHolder();

//Base:
difference(){
	union(){
			laserTrack();
			MirrorBSlots();
			translate([mirrorsToBHolder_X,-mirrorAToLaserTrack_Y])
				rotate(-90)
					FrameSnap();
	}
	translate([mirrorsToBHolder_X,-mirrorAToLaserTrack_Y])
			rotate(-45+90)
				MirrorASlots();
}

	
