/**
 *  @author Kenneth Mark Labrador
 *  @date 02.19.2016
 *  @description Upload Property Floater
 */
function showUploadPropertyFloater(parId) {
	try {
		overlayUploadPropertyFloater = Overlay.show(contextPath + "/OverlayController", {
			title : "Property Floater Uploading Module",
			urlContent : true,
			urlParameters : {
				action : "showUploadPropertyFloater",
				parId : parId
			},
			width : 640,
			height : 330,
			draggable : true
		});
		
	} catch(e) {
		showErrorMessage("showUploadPropertyFloater", e);
	}
}