/**
 * 
 * @param canvasElement
 */
function initPackRoadMap(canvasElement){
	isPack = true;
	moduleDirectory = new Array();
	roadmapCanvasElement = $(canvasElement); 
	roadmapCanvasElement.addEventListener("click", clickPackRoadMap, false);
	roadmapCanvasElement.addEventListener("mousemove", packRoadmapOnMouseOver, false);
	roadmapCanvasElement.addEventListener("mouseout", function(){$("packRoadMapCanvasLabel").innerHTML = "";}, false);
	roadmapContext = roadmapCanvasElement.getContext("2d");
	drawPackRoadMap(roadmapContext);
}