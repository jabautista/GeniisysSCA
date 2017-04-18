/**
 * Shows Credit/Debit Memo Info Page
 * 
 * @author Kris Felipe
 * @module GIACS071
 * @date 03.20.2013
 */
function updateMemoInformation(cancelFlag, branchCd, fundCd) {
	new Ajax.Updater("mainContents", contextPath
			+ "/GIACMemoController?action=updateMemoInformation", {
		method : "GET",
		asynchronous : true,
		evalScripts : true,
		parameters : {
			gaccTranId : objACGlobal.gaccTranId,
			cancelFlag : cancelFlag,
			fundCd : fundCd,
			branchCd : branchCd
		},
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete : function(response) {
			if (checkErrorOnResponse(response)) {
				hideNotice("");
			}
		}
	});
}