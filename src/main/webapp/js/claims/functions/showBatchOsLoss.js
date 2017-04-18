/**
 * Shows Batch O/S Takeup page
 * Module: GICLB001 - Batch O/S Takeup
 * @author Robert Virrey
 * @date 01.16.2012
 */
function showBatchOsLoss(){
	new Ajax.Updater("dynamicDiv", contextPath+"/GICLTakeUpHistController?action=showBatchOsLoss",{
		method:"GET",
		evalScripts:true,
		asynchronous: true,
		onCreate: showNotice("Loading Batch O/S Takeup, please wait..."),
		onComplete: function () {
			hideNotice("");
			Effect.Appear($("dynamicDiv").down("div", 0), {duration: .001}); 
			setDocumentTitle("Batch O/S Takeup");
		}
	});
}