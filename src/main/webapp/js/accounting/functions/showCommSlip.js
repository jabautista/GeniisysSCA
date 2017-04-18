/*
 * * Created By: d.alcantara, 03-17-2011
 */
function showCommSlip() {
	new Ajax.Updater("officialReceiptMainDiv", contextPath
			+ "/GIACCommSlipController?action=showCommSlip", {
		parameters : {
			gaccTranId : objACGlobal.gaccTranId,
			page : 1
		},
		asynchronous : false,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading OR Preview...");
		},
		onComplete : function() {
			hideNotice("");
		}
	});
}