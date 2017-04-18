/**
 * Shows Final Loss Report Page
 * Module: GICLS034
 * @author Marco Paolo Rebong
 * @date 02.16.2012
 */
function showFinalLossReport(){
	new Ajax.Updater("basicInformationMainDiv", contextPath+"/GICLReserveSetupController?action=getItemInformation",{
		method: "GET",
		parameters: {
			claimId : objCLMGlobal.claimId,
			lineCd : objCLMGlobal.lineCd,
			menuLineCd : objCLMGlobal.menuLineCd,
			prelim : "N"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Loading Final Loss Report Page, please wait..."),
		onComplete: function() {
			hideNotice("");
			Effect.Appear($("basicInformationMainDiv").down("div", 0), {duration: .001});
			setDocumentTitle("Final Loss Report");
			setModuleId("GICLS034");
			objGIPIS100.callingForm = "GICLS034"; // andrew - 04.23.2012 - for view policy information
		}
	});
}