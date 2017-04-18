/**
 * Shows generic override request window, search project for example usage
 * @author andrew robes
 * @date 04.13.2012
 * @param moduleId
 * @param functionCode
 * @param onOk
 * @param onCancel
 */
function showGenericOverrideRequest(moduleId, functionCode, onOk, onCancel){
	overlayOverrideRequest = Overlay.show(contextPath+"/GIISController", {
		urlContent: true,
		urlParameters: {action : "showOverrideRequest",
						moduleId : moduleId,
					    functionCode : functionCode,
						ajax : "1"},
	    title: "Override Request",
	    height: 140,
	    width: 450,
	    draggable: true
	});
	
	overlayOverrideRequest.onOk = onOk;
	// NOTE: add the following to the Ajax onComplete of your onOk function if you want to close the overlay window :
		// overlayOverrideRequest.close();
		// delete overlayOverrideRequest;
	overlayOverrideRequest.onCancel = onCancel;
}