/**
 * @module GIACS283
 * @description List of  Postdated checks
 * @author John Dolon
 * @date 9.3.2014
 */
function showPrintPostDatedChecks() {
	try {
		overlayPrintPostDatedChecks= Overlay.show(contextPath
				+ "/GIACPdcChecksController", {
			urlContent : true,
			urlParameters : {
				action : "showPrintPostDatedChecks",
				ajax : "1",
				},
			title : "List of Post Dated Checks",
			 height: 255,
			 width: 503,
			draggable : true
		});   
	} catch (e) {
		showErrorMessage("showPrintPostDatedChecks", e);
	}
}