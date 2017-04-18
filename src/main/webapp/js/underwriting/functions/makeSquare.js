/**
 * Draws the square
 * @param context
 * @param x - x coordinate of starting position
 * @param y - y coordinate of starting position
 * @param w - pixel width of the square
 * @param status - state of the module (current [position], available, restricted, inaccessible)
 * @param funcWhenAvailable - function to be used when the 'button' is clicked
 * @param moduleDesc - module description/name to be displayed when mouseOver
 */
function makeSquare(context, x, y, w, status, funcWhenAvailable, moduleId, moduleDesc){
	// draw the event listener area
	context.beginPath();
	context.moveTo(x, y);	context.lineTo(x + w, y);
	context.lineTo(x + w, y + w);	context.lineTo(x, y + w);
	context.closePath();

	context.fillStyle = "#A4A4A4";
	context.strokeStyle = "#4A4344";
	context.fill();
	context.stroke();
	
	// DRAW THE IMAGE ICONS HERE
	// DRAW THE BLACK PATHS HERE
	status = status == null || status == undefined ? "INACCESSIBLE" : status; // nica 10.07.2011 - to handle null status
	
	var ic = new Icons();
    if(status == "AVAILABLE"){
    	ic.available(context, x+3, y+3);
	}else if(status == "CURRENT"){
		ic.current(context, x+3, y+3);
		if($("rmCurrModule") != null){
			$("rmCurrModule").innerHTML = moduleDesc;
		}
	}else if(status == "RESTRICTED" ){
		ic.restricted(context, x+3, y+3);
	}else if(status == "INACCESSIBLE" ){
		ic.inaccessible(context, x+3, y+3);
	}
    var aSquare = new SquareArea(x, y, w, status, funcWhenAvailable, moduleId, moduleDesc);
    moduleDirectory.push(aSquare); // adds the square to an array for later reference
}