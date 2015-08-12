



	
laserCutWidth=.16;				//thickness of plastic removed when cutting (diameter rather than radius)
//acetate:
//laserCutWidth=.7;

sheet=2.96;						//thickness of sheet
sheet_A=sheet-laserCutWidth;	//corrected for laser cut


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

										//distance from the laser to the Mirror B Holder
//End of Variables




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

	}		

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




//----------------Call Modules:-----------------


linear_extrude(height=3) BFrameHolder();
