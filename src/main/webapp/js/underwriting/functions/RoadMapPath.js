/**
 * @param context
 * @param pathId
 * @param startCoordinates
 * @param endCoordinates
 * @param status
 * @returns {RoadMapPath}
 */
function RoadMapPath(context, pathId, startCoordinates, endCoordinates, status){
	this.startCoordinates = startCoordinates;
	this.endCoordinates = endCoordinates;
	this.id = pathId;
	this.status = status;
} 