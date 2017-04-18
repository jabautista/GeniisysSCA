/**
 * Calls the overlay for posting batch distribution.
 * Module: GIUWS015
 * @return
 */
function postBatchDistribution(){
	overlayBatchPost = Overlay.show(contextPath+"/GIUWPolDistFinalController", { 
				urlContent: true,
				urlParameters: {action : "showPostBatchDistOverlay",
								ajax : "1"},
			    title: "Posting Distribution",
			    height: 130,
			    width: 510,
			    draggable: true
	});
}