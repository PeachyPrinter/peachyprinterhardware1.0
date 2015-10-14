t=0.01;
outside=[17,10];
notch_l=[0,10-4];
notch=[10,t];

difference(){
    square(outside);
    translate(notch_l) square([outside[0],t]);
    translate([notch[0],notch_l[1]]) square([t,outside[1]-notch_l[1]]);
}