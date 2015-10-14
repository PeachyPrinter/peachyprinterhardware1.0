function In(in) = in*25.4;
box_inner=[In(8)-3,In(4+3/4)+2,In(2)];
circuit=[In(1+3/4),In(2+7/8)];
parts=[In(3+1/2),In(3+3/4)];

spacing=[(box_inner[0]-circuit[0]-parts[0])/3,(box_inner[1]-circuit[1])/2,(box_inner[1]-parts[1])/2];

difference(){
    square([box_inner[0],box_inner[1]]);
    translate([spacing[0],spacing[1]]) square(circuit);
    translate([spacing[0]*2+circuit[0],spacing[2]]) square(parts);
}

