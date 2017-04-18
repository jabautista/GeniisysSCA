function showGicls070OverrideRequest(canvas){
	overlayOverrideRequest = Overlay.show(contextPath+"/GICLMcEvaluationController", {
		urlContent: true,
		urlParameters: {action : "showOverrideRequest",
						moduleId : "GICLS070", // module for LOA/CSL printing
					    functionCode : "LO",
					    canvas: canvas,
						ajax : "1"},
	    title: "Override Request",
	    height: 140,
	    width: 450,
	    draggable: true
	});
}