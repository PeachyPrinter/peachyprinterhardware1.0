d=6-0.3;
r=d/2;
th=2;
t=0.01;
$fn=40;

handle=[3,15];

difference(){
    circle(r+th);
    circle(r);
    translate([0,-r-th])square([t,th]);
}
translate([-handle[0]/2,r]) square(handle);