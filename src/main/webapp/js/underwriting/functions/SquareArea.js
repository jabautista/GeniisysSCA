/**
 * Class that defines a clickable area's location/actionOnClick/status/titleOnHover
 * @param x
 * @param y
 * @param w
 * @param status
 * @param funcWhenAvailable
 * @param moduleDesc
 * @returns {SquareArea}
 */
function SquareArea(x, y, w, status, funcWhenAvailable, moduleId, moduleDesc){
	this.x = x;
	this.y = y;
	this.w = w;
	this.status = status;
	this.moduleId = moduleId;
	this.funcWhenAvailable = funcWhenAvailable;
	
	this.moduleDesc = moduleDesc;
	this.isWithinSquare = function(xPos,yPos){
		if( xPos > this.x - 1 && xPos < this.x + this.w + 1 &&
			yPos > this.y - 1 && yPos < this.y + this.w + 1){
			return true;
		}else{
			return false;
		}
	};
}