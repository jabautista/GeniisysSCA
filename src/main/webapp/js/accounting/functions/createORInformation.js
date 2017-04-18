function createORInformation(branchCd) {
	var now = new Date();
	objACGlobal.gaccTranId = null;
	new Ajax.Updater("mainContents", contextPath
			+ "/GIACOrderOfPaymentController?action=createORInformation", {
		method : "GET",
		parameters : {
			tranDate : now.format("mm-dd-yyyy"),
			branchCd : branchCd
		},
		asynchronous : true,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete : function(response) {
			if (checkErrorOnResponse(response)) {
				hideNotice("");
				$("acExit").show(); // added by andrew - 02.18.2011
				hideAccountingMainMenus();
			}
			// showConfirmBox("Create DCB_NO", "There is no open DCB No. for " +
			// now.format("mm-dd-yyyy") + ". Create one?", "Yes", "No",
			// showDCBReminderDetails,"");
		}
	});

}