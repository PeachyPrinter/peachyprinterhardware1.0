


module box(H=40,X=240,Y=120,s=4,t=0.01){
    //bottom
    translate([H+t,0]) square([X+s*2,H]);
    
    translate([H+t,H+t]) square([X+s*2,Y+s]);
    translate([0,H+t]) square([H,Y+s]);
    
    translate([H+t*2+X+s*2,H+t]) square([H,Y+s]);
    
    translate([H+t,H+t*2+Y+s]) square([X+s*2,H]);
    
    translate([0,H+t*3+Y+s+H]){
        
        translate([s,0]) square([H,Y]);
        translate([s+H+X+t*2,0]) square([H,Y]);
        
        translate([s+H+t,0]) square([X,Y]);
        
        translate([H,Y+t]) square([X+s*2,H]);
    }
    //top
}

module cornerBrace(H=40,s=4,w=50,t=0.01){
    square([w,H+s*2]);
    translate([w+t,0])square([w,H+s*2]);
    
    translate([0,H+s*2]) triangles(H,s,w,t);
    rotate(180) mirror([1,0,0]) triangles(H,s,w,t);    
}
module triangles(H=40,s=4,w=50,t=0.01){
    polygon([[0,t],[w/2,tan(45)*w/2],[w,t]]);
    translate([w+t,0]) polygon([[0,t],[w/2,tan(45)*w/2],[w,t]]);
}

box();
translate([330,0])
cornerBrace();