/**
 * Shows the Batch Claim Closing Page
 * @author Christian Santos
 */
function showBatchClaimClosing(statusControl){
	try {
		new Ajax.Updater("dynamicDiv", contextPath + "/GICLClaimsController?action=showBatchClaimClosing", {
			method: "GET",
			parameters: {
				statusControl: nvl(statusControl, 1)
			},
			asynchrous: true,
			evalScripts: true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				hideNotice("");
			}
		});
	} catch(e){
		showErrorMessage("showBatchClaimClosing", e);
	}
}