/* -----For use with SmartCarve:------

	this tool will create double lines separated by ~t --> make t=1 to see effect, change module oneLine to change effect
	to remove double lines in SmartCarve:
		"scatter group"	
		"find overlap" --> precision usually 0.005mm, but some number larger than t, and less than laser kerf

*/
/* -----how to use-----
	two options: 
		single line: length l, angle a
		multi line: points [[x1,y1],[x2,y2],....], closed=true makes it a closed polygon
        see bottom for examples
	*/



//tiny number: (too small and things disappear)
	t=0.01;


module line(l=0,a=0,points=0,closed=0){

	//initiate recursion for multi line
		if (points!=0) pointsToLines(points,len(points),closed);

	//make single line
		if (l!=0) rotate(a) square([l,t]);

}


//recursion magic for multi line...
	module pointsToLines(points,i,closed=0){

		//add line to make the loop closed, done on first recursion
			if(closed==true && i==len(points)-1) oneLine(points[i],points[0]);
	
		//make a line each iteration
			oneLine(points[i],points[i-1]);
	
		//make recursion end when i counts down to 1
			i=i-1;
			if (i>1) pointsToLines(points,i);

	}
//...end recursion magic




//for making each line between two points
	module oneLine(a,b){
		polygon([a,a+[t,t],b,b+[t,t]]);
	}


//test example points:
	//test=[[3,5],[3,9],[1,10],[-1,5],[5,6]];
test=[[1,1],[2,4],[3,0],[1,1]];
//make test example
	line(points=test);
