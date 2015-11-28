$fn = 50;

partsPlate();

tightness = .07;

laserCurf = .2;

rulerLength = 200;
rulerWidth = 30;
shortLineThickness = .1;
longLineThickness = .15;
shortLineLength = rulerWidth/20;
longLineLength = rulerWidth/10;
pegLength = 1;

fastnerHoleDiameter = 1; // (sp) fastener
textHeight = 2;



sheetThickness = 3;
wallThickness = 3;
centerDiskRadius = rulerWidth/2 - wallThickness *2 - pegLength ;

lineLensDiameter = 3.16;
extraLaserHeight = 7;
pegLength = 3;
laserHousingDiameter = 5.97;
laserHeight = laserHousingDiameter/2 + wallThickness*2 + extraLaserHeight;
laserMountWidth = laserHousingDiameter + wallThickness*2;
laserMountHeight = sheetThickness + wallThickness * 2 + laserHousingDiameter + extraLaserHeight;
laserOrigin = rulerWidth * 1.5;
flextureThickness = 1.5;


partsPlateGap = 2;

module partsPlate()
{
    rulerBody();
    translate([0,rulerWidth + partsPlateGap,0])
    laserMount();
    translate([laserMountWidth + partsPlateGap,rulerWidth + partsPlateGap,0])
    lineLensMount();
    
}
//partsPlate();




module laserMount()
{
difference()
    {
        square([laserMountWidth,laserMountHeight]);
        
        translate([laserMountWidth/2,laserHeight,0])
        circle(laserHousingDiameter/2 - laserCurf/2 - tightness);
        translate([laserMountWidth/2,wallThickness,0])
        #square([.01,laserMountHeight - wallThickness * 2]);
    }
}
//laserMount();

module lineLensMount()
{
difference()
    {
        square([laserMountWidth,laserMountHeight]);
        
        translate([laserMountWidth/2,laserHeight,0])
        circle(lineLensDiameter/2 - laserCurf/2 - tightness);
        translate([laserMountWidth/2,wallThickness,0])
        #square([.01,laserMountHeight - wallThickness * 2]);
    }
}
//lineLensMount();

module laserMountHole()
{
    translate([laserOrigin,rulerWidth/2 -laserMountWidth/2,0]){
    square([sheetThickness - tightness - laserCurf,laserMountWidth]);
        translate([-flextureThickness,0,0])
    square([.01,laserMountWidth]);
    }

    }
// laserMountHole();

module lineLensMountHole()
{
    
    translate([laserOrigin- wallThickness,rulerWidth/2 - sheetThickness - laserHousingDiameter/2 ,0])rotate(90){
    square([sheetThickness - tightness - laserCurf,laserMountWidth]);
        translate([-flextureThickness,0,0])
    square([.01,laserMountWidth]);
    }
}
    
// lineLensMountHole();
    
    
module shortLine()
{
square([shortLineLength, shortLineThickness]);
}


module longLine()
{
square([longLineLength, longLineThickness]);
}

module degLines(mirror=false)
{
for (i = [-90:10:90] )
{
    rotate(i)
    translate([centerDiskRadius,0,0])
    #shortLine();
    echo( i);
}
for (i = [-90:45:90] )
{
    rotate(i)
    translate([centerDiskRadius,0,0]){
    longLine();
      if (i >= 0) {  
          if (mirror==false) translate([textHeight*1.5,0,0])   text(str(i),2);   
          else translate([textHeight*1.5,0,0]) rotate(180) mirror([1,0,0])  text(str(i),2); 
      }
}
}
}

module circleScribe(r=20,offC=-7,s=1.5){
    rotate(-asin(offC/r))translate([r,0]){
        circle(s);
        translate([0,s])
        text(str(r/10),2);
    }
    
}
module circleScribes(r=20,offC=-7,s=1.5){
    for(i=[60:20:170]){
        circleScribe(i);
    }
}

module rule(step,len,height,width=0.2,txt,mirror=false){
//change direction******************
for(i=[0:len/step]){
        translate([i*step,0]) square([width,height]);
        if (step>5&&step*i>0) translate([i*step,height]) {
            if(mirror==false)text(str(step*i/10),2);
            else mirror([1,0,0])text(str(step*i/10),2);
        }
}
}
module rulings(len=20,mirror=false){
    rule(10,len,4,mirror=mirror);
    rule(5,len,2.5,mirror=mirror);
    rule(1,len,1.5,mirror=mirror);
}



module rulerBody()
{
    difference()
    {
        square([rulerLength, rulerWidth]);
    translate([centerDiskRadius + wallThickness, rulerWidth/2, 0]){
    
    centerDiskHole();
    degLines();
    circleScribes();
    }
    translate([rulerLength-centerDiskRadius - wallThickness, rulerWidth/2, 0])mirror([1,0,0]){
    centerDiskHole();
    degLines(mirror=true);
    }
    translate([60,rulerWidth/2,0])
    centerDisk();
    translate([rulerLength-40,rulerWidth/2,0])
    centerDisk();
    laserMountHole();
   #lineLensMountHole();
    
        translate([rulerLength,0.01]) mirror([1,0,0])
            rulings(rulerLength-1,mirror=true);

}

}
//rulerBody();

module centerDisk()
{
difference()
{
circle(centerDiskRadius);
translate([0,centerDiskRadius/2,0])
circle(fastnerHoleDiameter);
translate([0,-centerDiskRadius/2,0])
circle(fastnerHoleDiameter);
circle(fastnerHoleDiameter);

}
}

module centerDiskHole()
{
circle(centerDiskRadius - laserCurf);   
}






