
/*--------------------Snap1:---------------------------

	parameters:
	ridge_X,ridge_Y
		-ridge that stops B from going left (on bottom)
	notch_x,notch_y
		-notch on top that holds B in place
	notch_taper
		-to allow for different thickness on sheets
	curve
		-radius of arc
	arc
		-degrees of the circle from the tightest point to the resting point when snapped
	edges
		-edges on 360 degrees of the circle
	length
		-length of the track taken up by this module
	width
		-width of the track
	cut
		-width of the cut
	thick
		-width of the bending part
	extraTension
		-tension after the mount is snapped in
*/
module Snap1A(ridge_X=2, ridge_Y=1, notch_x=2,notch_y=.65,notch_taper=.2, curve=2.5, arc=40, edges=45, length=22, width=10, cut=1.5, thick=2.9, extraTension=0.4,sheet_A=2.66){		
	//laser mounts snap into this
	//zero x coord is left edge of mount

	//add ridge to stop mount from going further left
	translate([-ridge_X,-ridge_Y])
		square([ridge_X,ridge_Y]);
	translate([-ridge_X,0])
		square([ridge_X,width]);

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
		translate([-notch_x,width])
			polygon([[0,0],[0,ridge_Y],[ridge_X+.000505-notch_taper,ridge_Y],[ridge_X+.000505,0]]);
			
		translate([sheet_A,width])

			polygon([[0,0],[+notch_taper,notch_y],[notch_x+.000505,0]]);
}
module Snap1B(width=10,thick=1.5, sheet_A=2.66, cut_y=1.2,cut_x=2,cut_t=.1){	
	translate([-thick-cut_x,-thick])
	difference(){
		square([width+thick*2+cut_x*2,sheet_A+thick*2+cut_y]);
		translate([thick+cut_x,thick]) square([width,sheet_A]);
		translate([thick+width/2+cut_x,thick+sheet_A]) square([cut_x*2+width,.001],center=true);
		translate([thick+width/2+cut_x,thick+sheet_A+cut_y]) square([cut_x*2+width,cut_t],center=true);
	}		

}

 Snap1B();