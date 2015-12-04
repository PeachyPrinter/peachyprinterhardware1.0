
rodDiameter = 6;
slotWidth = 4; // could be defined using sheet thickness, cos and rodDiameter..
slotLength = 100;
nSlots = 10;

laserCurf = .2;
sheetThickness = 3;
laserHousingDiameter = 4;
lensLength = sheetThickness + laserHousingDiameter + laserCurf;

overCutLength = 1;

totalCutLength = rodDiameter + overCutLength * 2;
rowGap = 4;

rodCutWidth = .01;
trayCutRelifWidth = 2;

module chopLines(cutWidth = .01)
{
    for (i = [0:lensLength:slotLength])
    {
        translate([i - cutWidth/2,0,0])
        square( [cutWidth, totalCutLength]);
        //echo(i);
    }
}
//chopLines();

module slot()
{
    translate([0,totalCutLength/2 - slotWidth/2])
    square( [slotLength, slotWidth] );
}
//slot();

module tray()
{
    difference()
    {
        square([slotLength + rowGap * 2, nSlots * (totalCutLength + rowGap) + rowGap]);
    for (i = [0:totalCutLength + rowGap:nSlots * (totalCutLength + rowGap)])
    {
        translate([rowGap,i + rowGap,0])
        {
        #slot();
        chopLines(cutWidth = trayCutRelifWidth);
        }
    }
}
}
//tray();

module cuts()
{
    difference()
    {
        square([slotLength + rowGap * 2, nSlots * (totalCutLength + rowGap) + rowGap]);
    for (i = [0:totalCutLength + rowGap:nSlots * (totalCutLength + rowGap)])
    {
        translate([rowGap,i + rowGap,0])
        {
        
        chopLines(cutWidth = rodCutWidth);
        }
    }
}
}
//cuts();
    
module partsPlate()
{
    tray();
    translate([0,nSlots * (totalCutLength + rowGap) + rowGap +1,0])
    cuts();
}
partsPlate();
    