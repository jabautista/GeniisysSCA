function showGIACS155() { // Commission Voucher - Pol 5.31.2013
	try {
		new Ajax.Request(contextPath + "/GIACCommissionVoucherController", {
			parameters : {
				action : "showGIACS155"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					hideAccountingMainMenus();
					$("mainContents").update(response.responseText);
					$("acExit").show();
				}
			}
		});
	} catch (e) {
		showErrorMessage("Commission Voucher Error", e);
	}
}