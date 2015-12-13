lengthen=3;

difference(){
    
    translate([1.5,0]) square([33+lengthen,15]);
    translate([8-3-1.45,10])square([1.45,10]);
    translate([8+14.3+lengthen,10-6])rotate(-45)square([2.8,11.6]);
    translate([26+lengthen,0])rotate(-45)square(30);
    translate([7,11.5]) square(100);
    
}