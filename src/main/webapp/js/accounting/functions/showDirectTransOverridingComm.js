
/**
 * Show Direct Trans Overriding Comm Payts module GIACS040
 * 
 * @author eman
 * @return
 */
function showDirectTransOverridingComm() {
	new Ajax.Updater("transBasicInfoSubpage", contextPath
			+ "/GIACOvrideCommPaytsController?action=showOverridingComm", {
		method : "GET",
		parameters : {
			gaccTranId : objACGlobal.gaccTranId
		},
		asynchronous : true,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading Overriding Comm Payts...");
		},
		onComplete : function() {
			hideNotice("");
		}
	});
}