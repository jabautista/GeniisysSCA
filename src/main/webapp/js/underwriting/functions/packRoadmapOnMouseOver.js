/**
 * 
 * @param e
 */
function packRoadmapOnMouseOver(e){
	var coordinates = getCursorPosition(e);
	var found = false;
	var currentSquare = null;
	for(var i = 0; i<moduleDirectory.length; i++){
		currentSquare = moduleDirectory[i];
		if(currentSquare.isWithinSquare(coordinates.x-22, coordinates.y-29)){
			found = true;
			i = moduleDirectory.length;
		}
	}
	
	if(found){
		$("packRoadMapCanvasLabel").innerHTML = currentSquare.moduleDesc;
	}else{
		$("packRoadMapCanvasLabel").innerHTML = "";
	}
}