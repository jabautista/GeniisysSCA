/**
 * Gets the position of the mouse based on event e
 * @param e
 * @returns {Coordinates}
 */
function getCursorPosition(e){
    /* returns Cell with .row and .column properties */
    var x;// = e.layerX;
    var y;// = e.layerY;
    
    if (e.layerX || e.layerX == 0) { // Firefox
    	x = e.layerX;
        y = e.layerY;
    } else if (e.offsetX || e.offsetX == 0) { // Opera
    	x = e.offsetX;
    	y = e.offsetY;
	}
    
    var coordinates = new Coordinates(x,y);
    return coordinates;
}