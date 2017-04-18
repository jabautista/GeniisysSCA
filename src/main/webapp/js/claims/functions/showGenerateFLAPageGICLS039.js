/**
 * Call Generate Final Loss Advice Page from Batch Claim Closing
 * Module: GICLS033
 * @author Christian Santos
 * @date 12.06.2012
 */
function showGenerateFLAPageGICLS039(){
	new Ajax.Updater("dynamicDiv", contextPath+"/GICLAdvsFlaController",{
		method: "GET",
		parameters: {
			action  : "showGenerateFLAPage",
			claimId : objCLMGlobal.claimId,
			callingForm: "GICLS039"
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Loading Generate FLA Page, please wait..."),
		onComplete: function() {
			hideNotice("");
			Effect.Appear($("dynamicDiv").down("div", 3), {duration: .001});
			objGIPIS100.callingForm = "GICLS039";
		}
	});
}