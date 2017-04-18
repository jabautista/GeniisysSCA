function showContingentProfitCommission() { // Kris 07.24.2013
	try {
		new Ajax.Request(contextPath + "/GIACGeneralDisbursementReportsController", {
			parameters : {action : "showContingentProfitCommission"},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading Contingent Profit Commission Page, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				$("mainContents").update(response.responseText);
				hideAccountingMainMenus();
				$("acExit").show();
			}
		});
	} catch(e){
		showErrorMessage("showContingentProfitCommission", e);
	}
}