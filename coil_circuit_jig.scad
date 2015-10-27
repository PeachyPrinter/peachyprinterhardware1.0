N=12;
L=143;
R=0.89/2;

T=0.01;

X1=168.46;
Y1=16.36;
Yoff=1.2;

W=10;
W2=25;
W3=12;

$fn=30;

difference(){
    square([X1+W*2,Y1+W*2+W2*2]);
    translate([W,W+W2+Yoff]) square([X1,Y1]);
    translate([W*1.5,W]) square([X1-W,Y1+W2*2]);
}
translate([0,Y1+W*2+W2*2+T]){
    difference(){
        square([X1+W*2,Y1+W*2+W2*2]);
        translate([W*1.5,W]) square([X1-W,W2+W3/2]);
        translate([W*1.5,W+Y1+W2-W3/2]) square([X1-W,W2+W3/2]);
        translate([X1+W*2,Y1+W*2+W2*2]/2) circles(N);
    }   
}

module circles(n){
    remain=n%2;
    for(i=[-n:n]){
        if((i%2==0&&remain==1)||((i%2==1||i%2==-1)&&remain==0)) translate([L/(n-1)/2,0]*i) circle(R);  
    }
}