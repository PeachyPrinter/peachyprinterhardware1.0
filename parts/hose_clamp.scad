r=7.2/2;
d=1;
t=3;
$fn=40;

difference(){
    hoop(r+t,d);
    hoop(r,d);
}


module hoop(s,x){
    translate([-x/2,0]) circle(s);
    translate([-x/2,-s]) square([x,s*2]);
    translate([x/2,0]) circle(s);
    
}