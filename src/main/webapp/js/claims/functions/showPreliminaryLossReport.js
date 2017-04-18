/**
 * Shows Preliminary Loss Advice
 * Module: GICLS028
 * @author Niknok Orio
 * @date 02.15.2012
 */
function showPreliminaryLossReport(){
	new Ajax.Updater("basicInformationMainDiv", contextPath+"/GICLReserveSetupController?action=getItemInformation",{
		method: "GET",
		parameters: {
			claimId : nvl(objCLMGlobal.claimId, 0),
			lineCd : nvl(objCLMGlobal.lineCd, ""),
			menuLineCd : nvl(objCLMGlobal.menuLineCd, ""),
			prelim : "Y"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Loading Preliminary Loss Report Page, please wait..."),
		onComplete: function() {
			hideNotice("");			
			Effect.Appear($("basicInformationMainDiv").down("div", 0), {duration: .001});
			setDocumentTitle("Preliminary Loss Report");
			setModuleId("GICLS029");
			objGIPIS100.callingForm = "GICLS029"; // andrew - 04.23.2012 - for view policy information
		}
	});
}