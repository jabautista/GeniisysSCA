/**
 * Shows Generate Final Loss Advice Page
 * Module: GICLS033
 * @author Marco Paolo Rebong
 * @date 03.29.2012
 */
function showGenerateFLAPage(){
	new Ajax.Updater("basicInformationMainDiv", contextPath+"/GICLAdvsFlaController",{
		method: "GET",
		parameters: {
			action  : "showGenerateFLAPage",
			claimId : objCLMGlobal.claimId
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Loading Generate FLA Page, please wait..."),
		onComplete: function() {
			hideNotice("");
			Effect.Appear($("basicInformationMainDiv").down("div", 0), {duration: .001});
			objGIPIS100.callingForm = "GICLS033"; // andrew - 04.23.2012 - for view policy information
		}
	});
}