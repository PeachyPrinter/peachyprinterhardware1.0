one=[6.5,10];
two=[9.85,2.6];
sep=[34+3-2.5+one[0]/2,2.5+one[1]/2];
th=2;
flx=[1.3,0.01];

difference(){
	square([two[0]+sep[0]+th*2+one[0]/2,sep[1]+one[1]/2+th*2]);
    
	translate([th+one[0]/2,th+sep[1]])square(one,center=true);
    translate([th+one[0]+flx[0],th+sep[1]]) square([flx[1],one[1]],center=true);
    
	translate([th+sep[0]+one[0]/2,th])square(two);
    translate([th+sep[0]+one[0]/2,th+two[1]+flx[0]])square([two[0],flx[1]]);
}