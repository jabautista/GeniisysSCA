function showGicls030OverrideRequest(reqExists, canvas){
	overlayOverrideRequest = Overlay.show(contextPath+"/GICLLossExpDtlController", {
		urlContent: true,
		urlParameters: {action : "showOverrideRequest",
						moduleId : "GICLS070", // module for LOA/CSL printing
					    functionCode : "LO",
					    reqExists: reqExists,
					    canvas: canvas,
						ajax : "1"},
	    title: "Override Request",
	    height: 140,
	    width: 450,
	    draggable: true
	});
}