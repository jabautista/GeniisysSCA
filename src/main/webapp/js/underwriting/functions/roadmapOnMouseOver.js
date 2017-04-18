/**
 * 
 * @param e
 */
function roadmapOnMouseOver(e){
	var coordinates = getCursorPosition(e);
	var found = false;
	var currentSquare = null;
	for(var i = 0; i<moduleDirectory.length; i++){
		currentSquare = moduleDirectory[i];
		if(currentSquare.isWithinSquare(coordinates.x-35, coordinates.y-28)){
			found = true;
			i = moduleDirectory.length; // end loop
		}
	}
	
	if(found){
		$("roadMapCanvasLabel").innerHTML = currentSquare.moduleDesc;
		/*writeHoverMessage(currentSquare.moduleDesc);
		document.body.style.cursor = 'pointer';*/
		/*	roadmapContext.fillStyle = '#3f3f3f';
			roadmapContext.fillRect(coordinates.x + 10, coordinates.y + 10, 70, 20);
			roadmapContext.fillStyle = '#fff';
			roadmapContext.font = 'bold 10px verdana';
			roadmapContext.fillText(moduleDesc, coordinates.x + 10, coordinates.y + 25, 60);
		*/
	}else{
		$("roadMapCanvasLabel").innerHTML = "";
		//clearHoverMessage();
	}
}