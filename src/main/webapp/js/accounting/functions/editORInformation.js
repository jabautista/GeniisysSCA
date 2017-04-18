function editORInformation() {
	new Ajax.Updater("mainContents", contextPath
			+ "/GIACOrderOfPaymentController?action=editORInformation", {
		method : "GET",
		asynchronous : true,
		evalScripts : true,
		parameters : {
			gaccTranID : objACGlobal.gaccTranId,
			branchCd : nvl(objACGlobal.branchCd, "HO")
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