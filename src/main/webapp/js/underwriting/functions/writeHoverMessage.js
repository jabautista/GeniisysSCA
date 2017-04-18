/**
 * 
 * @param message
 */
function writeHoverMessage(message){
	var x = 10; //120;
	var y = 440; //425;
	
	if(isPack){
		y = 455;
	}else{
		x = 10;
		y = 440;
	}
	
	roadmapContext.font = "10pt Calibri";
	roadmapContext.fillStyle = "Black";
	roadmapContext.fillText(message, x, y);
}