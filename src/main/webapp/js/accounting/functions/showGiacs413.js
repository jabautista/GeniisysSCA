function showGiacs413() { // Kris 06.28.2013
	try {
		new Ajax.Request(contextPath + "/GIACGeneralDisbursementReportsController", {
			parameters : {action : "showCommissionsPaidRegisterPage"},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {showNotice("Loading Commissions Paid Register Page, please wait...");},
			onComplete : function(response) {
				hideNotice("");
				$("mainContents").update(response.responseText);
				hideAccountingMainMenus();
				$("acExit").show();
			}
		});
	}catch(e){
		showErrorMessage("showGiacs413", e);
	}
}