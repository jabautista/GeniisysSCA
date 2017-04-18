function clearHoverMessage(){
	document.body.style.cursor='default';
	var x = 10;
	var y = 430;
	
	if(isPack){
		y = 445;
	}else{
		x = 10;
		y = 430;
	}
	
	roadmapContext.beginPath();
	roadmapContext.moveTo(x, y);
	roadmapContext.lineTo(x + 150, y);		
	roadmapContext.lineTo(x + 150, y + 15);
	roadmapContext.lineTo(x, y + 15);	
	roadmapContext.closePath();
	roadmapContext.fillStyle = "#FFFFFF";	
	roadmapContext.strokeStyle = "#FFFFFF";
	roadmapContext.fill();
	roadmapContext.stroke();
}