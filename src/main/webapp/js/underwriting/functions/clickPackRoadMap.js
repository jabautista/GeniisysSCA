/**
 * Defines the action to be done by canvas
 * note: canvas elements do not have their own event listeners... 
 * 		you have to specify the location where the event happened instead
 * 
 * @param e - event
 */
function clickPackRoadMap(e){
	var coordinates = getCursorPosition(e);	
	var found = false;
	var currentSquare = null;
	for(var i = 0; i<moduleDirectory.length; i++){
		currentSquare = moduleDirectory[i];
		
		if(currentSquare.isWithinSquare(coordinates.x-22, coordinates.y-29)){
			found = true;
			i = moduleDirectory.length;
			break;
		}
	}

	if(found){
		if(currentSquare.status == "AVAILABLE"){
			if(currentSquare.funcWhenAvailable!=null){
				currentSquare.funcWhenAvailable();
			}
		}else if(currentSquare.status == "INACCESSIBLE"){
			var screenName = currentSquare.moduleDesc;
			if(objRoadMapAvail.allowEntry == "N"){
				showMessageBox("The " + screenName + " screen is not available for access since user " +
					           "is not the processor of the selected PAR.", "E");
			}else{
				showMessageBox("Please complete the necessary transactions to process PAR in the " + 
				               screenName + " screen.", "I");
			}
		}else if(currentSquare.status == "RESTRICTED"){
			var screenName = currentSquare.moduleDesc; 
			showMessageBox("User does not have the right to access the " + 
					        screenName + " screen.", "I");
		}else if(currentSquare.status == "CURRENT"){
			winRoadMap.close();
		}
	}
}