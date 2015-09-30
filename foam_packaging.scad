//d3();
d2();



function In(in) = in*25.4;
box=[In(8)-3,In(4.75)+2,In(2)];
circuit=[In(2.75),In(1.75)];

foam= In(0.5)-1;
notch1=foam*2;
notch2=box[2]/2;




divider=In(3);


module cFoam(){
    square(circuit);
    translate([0,circuit[1]/2-notch1/2]) rotate(90) 
        square([notch1,foam]);
    translate([circuit[0]/2-notch1/2,circuit[1]])
        square([notch1,foam]);
}

module lFoam(){
    difference(){
        square([box[0],box[2]]);
        translate([divider,box[2]-notch2])
            square([foam,notch2]);
        translate([divider+foam+circuit[0]/2-notch1/2,0])
            square([notch1,foam]);
    }
}

module dFoam(){
    difference(){
        square([box[1],box[2]]);
        translate([box[1]/4,0]) square([box[1]/2,foam]);
    }

}

hold=10;
inset=45;

module bFoam(){
    difference(){
        polygon([[0,0],[0,hold],[inset,box[1]],[box[0]-inset,box[1]],[box[0],hold],[box[0],0]]);
        translate([box[0]/2-divider/2-foam,0])
            square([foam,box[1]/4]);
        translate([box[0]/2-divider/2-foam,box[1]*3/4])
            square([foam,box[1]/4]);
        translate([box[0]/2+divider/2,0])
            square([foam,box[1]/4]);
        translate([box[0]/2+divider/2,box[1]*3/4])
            square([foam,box[1]/4]);
    }
}

module d2(){    //2d
    dFoam();
    translate([140,0])
        cFoam();
    translate([-foam,60])
        lFoam();
    translate([220,0])
        bFoam();
}

module d3(){    //3d
    p1();
translate([0,box[1]-foam,0])
    p1();
translate([divider,0,0])
    p2();
translate([divider+foam,box[1]-foam-circuit[1],0])
    p3();
}

module p1(){
    translate([0,foam,0]) rotate([90,0,0]) linear_extrude(foam)
        lFoam(); 
}
module p2(){
    translate([0,foam,0]) rotate([90,0,90]) linear_extrude(foam)
        dFoam(); 
}
module p3(){
    translate([0,0,0]) rotate([0,0,0]) linear_extrude(foam)
        cFoam();
}

//8x4.75x2

//3x3.75
//2.75x1.75