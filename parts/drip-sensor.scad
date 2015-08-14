//$t =1;
dripGap = 7; 
outerWidth = 12+4;
sheetThickness = 3;
sourceHoseDiameter =3.3;
sourceHoseLength = 20;
drainHoseLength = 10;
wireHoleDiameter = .8;
extendTipLength = 0;// makes the tip longer without making it pointier 
contactTipLength =6; // as in the length of the pointy part, controls how pointy or blunt the tip is. 


wallThickness = 1.7+.5;
echo($t);

bottomTangLength = outerWidth-wallThickness ;
sourceHoseProtrusion= wallThickness * 2 + wireHoleDiameter + sheetThickness*2;
totalLength = sourceHoseLength + extendTipLength*2 +contactTipLength * 2 + dripGap + bottomTangLength - sourceHoseProtrusion;

resolution = 40;


tipWidth = wallThickness * 2 + sourceHoseDiameter;
wickGap = .3;

clipGap =.01;

sourceHoseRelifeHoleDiameter = sourceHoseDiameter *.7;

etchInfoSizeX = 17 ;
etchInfoSizeY = 5;





module contactTip()
{

	difference()
	{
		translate([tipWidth/2,extendTipLength,0])
			resize([0,2 * contactTipLength,0])
				circle(d = tipWidth, $fn = resolution);
		translate([0,-contactTipLength,0])
			square([tipWidth, contactTipLength]);
	
		translate([tipWidth/2, extendTipLength + contactTipLength ,0])
		{
			circle(d = wireHoleDiameter, $fn = resolution); // wire holes:
			translate([0,-wireHoleDiameter*3.5,0])
			{	
				translate([-wickGap/2,-extendTipLength - contactTipLength ,0])
				square([wickGap,extendTipLength + contactTipLength]); // wicking grove 
				circle(d = wireHoleDiameter, $fn = resolution);	
			}
			translate([0,-wireHoleDiameter*5.5,0])
				circle(d = wireHoleDiameter, $fn = resolution);	
	
		}
		

	}
	

}



module sourceHoseReciver()
{

	difference()
	{
		square([wallThickness * 2 + sourceHoseDiameter, sourceHoseLength + extendTipLength]);
		translate([wallThickness,0,0])
			square([sourceHoseDiameter, sourceHoseLength]);
		translate([(wallThickness * 2 + sourceHoseDiameter)/2,sourceHoseLength,0])
		rotate(30)	
			circle((wallThickness * 2 + sourceHoseDiameter)* .8 , $fn = 3, center = true);



	}
	

}
//#square([outerWidth,wallThickness]);

module cutBridge(cut)
{
difference()
	{
	square([outerWidth,wallThickness*2]);
	translate([outerWidth/2 - cut/2,0,0])
		square([cut,wallThickness*2]);
	

	}
}

module topCutBridge()
{
difference()
	{
	translate([-clipGap-wallThickness,-.5,0])
	square([outerWidth+clipGap+wallThickness,wallThickness+1]);
	translate([outerWidth/2 - sourceHoseDiameter/2,-.5,0])
		square([sourceHoseDiameter,wallThickness+1]);
	translate([0,wallThickness/2,0])
		{
		translate([outerWidth-(outerWidth/2 - sourceHoseDiameter/2)/2 ,0,0])
			circle(d = wireHoleDiameter, $fn = resolution );
		translate([(outerWidth/2 - sourceHoseDiameter/2)/2 ,0,0])
			circle(d = wireHoleDiameter, $fn = resolution );		
		}

	}
}
//topCutBridge();
//cutBridge(cut = 3);

//sourceHoseContact();
//contactTip();

hosePoke=[1,20];

module outerBody(iter)
{
difference()
	{
union()
	{
	square([wallThickness,totalLength]); // outer side wall
	translate([outerWidth-wallThickness,0,0])
		square([wallThickness,totalLength]); // outer side wall
	translate([-clipGap - wallThickness,.0001,0])
		square([wallThickness,totalLength]);// clip wall


	translate([outerWidth/2-tipWidth/2,bottomTangLength,0])
		contactTip(); // bottom contactTip()
	translate([0,bottomTangLength - wallThickness,0])
		cutBridge(cut = wickGap);
	difference()
	{	
		translate([outerWidth/2+tipWidth/2,bottomTangLength+ contactTipLength*2 + dripGap,0])
			rotate(180)
			contactTip(); // top contactTip()
		translate([outerWidth/2,bottomTangLength+ contactTipLength*2 + dripGap+.4,0])
			circle(.0001);
	}
    translate([outerWidth/2,bottomTangLength+ contactTipLength*2 + dripGap-1.1,0]) //square for hose to go into
        translate([-hosePoke[0]/2,0]) square(hosePoke);
    
	translate([outerWidth/2-tipWidth/2,bottomTangLength+ contactTipLength*2 + dripGap,0])
	sourceHoseReciver();
	translate([0,totalLength,0])
	topCutBridge();
        
        
        //translate([-etchInfoSizeX,totalLength,0])
        //etchInfo();
	}
	rotate(90)
		circle(d = wallThickness*3, $fn = 3); // cutts v shaped grove in clip opening
	translate([wallThickness/2,bottomTangLength,0])
			circle(d = wireHoleDiameter, $fn = resolution);


    }
}



module etchInfo(){
    difference(){
        square([etchInfoSizeX,etchInfoSizeY]);
        translate([0,wallThickness*.25,0])
        text(str("DripGap=",dripGap), size = wallThickness);
        translate([0,wallThickness* 1.5,0])
        text(previousCommitHash, size = wallThickness);
        
    }
    
        
        }
//etchInfo();

    outerBody();
