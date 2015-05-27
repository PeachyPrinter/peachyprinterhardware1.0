one=[2.5,7.5];
two=[9.85,2.6];
sep=[34,2.5];
t=2;

difference(){
	square([two[0]+sep[0]+t*2,sep[1]+one[1]+t*2]);
	translate([t,t+sep[1]])square(one);
	translate([t+sep[0],t])square(two);
}