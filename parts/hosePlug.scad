taper=0.5;
hoseID=6-1.5; //[1.5,7],[2.5,7],[2.7,8]
hoseOD=7;

width=[hoseOD,hoseID,hoseID-taper];
length=[4,11];

square([width[0],length[0]]);
translate([width[0]/2,length[0]]) 
    polygon([[-width[1]/2,0],[-width[2]/2,length[1]],[width[2]/2,length[1]],[width[1]/2,0]]);
mirror([0,1,0])
    translate([width[0]/2,0]) 
    polygon([[-width[1]/2,0],[-width[2]/2,length[1]],[width[2]/2,length[1]],[width[1]/2,0]]);
