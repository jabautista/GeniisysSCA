function showUploadFleetData(parId) {
	try {
		overlayUploadFleet = Overlay.show(contextPath + "/OverlayController", {
			title : "Fleet Data Uploading Module",
			urlContent : true,
			urlParameters : {
				action : "showUploadFleetData",
				parId : parId
			},
			width : 640,
			height : 320,
			//closable : true,
			draggable : true
		});
		
	} catch(e) {
		showErrorMessage("showUploadFleetData", e);
	}
}