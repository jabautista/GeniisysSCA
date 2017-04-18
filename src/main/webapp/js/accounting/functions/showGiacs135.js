function showGiacs135() { // Kris 06.28.2013
	try {
		new Ajax.Request(contextPath + "/GIACGeneralDisbursementReportsController", {
			parameters : {
				action : "showCheckRegisterPage"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading Check Register Page, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				hideAccountingMainMenus();
				$("mainContents").update(response.responseText);
				$("acExit").show();
			}
		});
	}catch(e){
		showErrorMessage("showGiacs135", e);
	}
}