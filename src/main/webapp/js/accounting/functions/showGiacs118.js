function showGiacs118() { // Kris 06.26.2013
	try {
		new Ajax.Request(contextPath + "/GIACGeneralDisbursementReportsController", {
			parameters : {action : "showDisbursementRegisterPage"},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading Cash Disbursement Register Page, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				$("mainContents").update(response.responseText);
				hideAccountingMainMenus();
				$("acExit").show();
			}
		});
	}catch(e){
		showErrorMessage("showGiacs118", e);
	}
}