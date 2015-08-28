one=[2.5,7.5];
two=[9.85,2.6];
sep=[34+3-one[0]/2,2.5+one[1]/2];
t=2;

difference(){
	square([two[0]+sep[0]+t*2+one[0]/2,sep[1]+one[1]/2+t*2]);
	translate([t+one[0]/2,t+sep[1]])square(one,center=true);
	translate([t+sep[0]+one[0]/2,t])square(two);
}