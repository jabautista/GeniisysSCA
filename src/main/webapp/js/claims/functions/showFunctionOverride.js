/**
 * Shows Function Override page
 * Module: GICLS183
 * @author Shan Krisne Bati
 * 12.18.2012
 */
function showFunctionOverride(){
	try{
		new Ajax.Updater("dynamicDiv", contextPath + "/GICLFunctionOverrideController?action=getGICLS183FunctionListing&refresh=1", {
			method: "GET",
			parameters: { },
			asynchronous: true,
			evalScripts: true,
			onCreate: function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				refreshFunctions();
			}
		});
	}catch (e){
		showErrorMessage("showFunctionOverride ", e);
	}
}