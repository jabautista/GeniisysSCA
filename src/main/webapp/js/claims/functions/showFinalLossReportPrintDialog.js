/**
 * Shows Final Loss Report Print Dialog
 * Module: GICLS034
 * @author Bonok
 * @date 05.08.2012
 */
function showFinalLossReportPrintDialog(){
	finalLossReportPrintDialog = Overlay.show(contextPath+"/GICLReserveSetupController", {
		urlContent : true,
		urlParameters: {
			action : "showFinalLossReportPrintDialog"
		},
	    title: "Print",
	    height: 165,
	    width: 380,
	    draggable: true
	});
}