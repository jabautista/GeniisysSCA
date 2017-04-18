/**
 * 
 * @param canvasElement
 */
function initRoadmap(canvasElement){
	isPack = false;
	moduleDirectory = new Array();
	roadmapCanvasElement = $(canvasElement); 
	roadmapCanvasElement.addEventListener("click", clickRoadMap, false);
	roadmapCanvasElement.addEventListener("mousemove", roadmapOnMouseOver, false);
	roadmapCanvasElement.addEventListener("mouseout", function(){$("roadMapCanvasLabel").innerHTML = "";}, false);
	roadmapContext = roadmapCanvasElement.getContext("2d");
	drawRoadMap(roadmapContext);
}