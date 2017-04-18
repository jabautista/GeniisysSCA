function checkUserAccessGiacs(moduleId) {
	try {
		new Ajax.Request(contextPath + "/GIISUserController", {
			method : "GET",
			parameters : {
				action : "checkUserAccessGiacs",
				moduleId : moduleId
			},
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response)) {
					if (response.responseText == 1) {
						if (moduleId == "GIACS410") {
							showPostEntriesToGLPage();
						} else if (moduleId == "GIACS117") { // added by shan
																// 06.13.2013
							showCashReceiptRegisterPage();
						} else if (moduleId == "GIACS093") { // added by shan
																// 06.17.2013
							showPDCRegisterPage();
						} else if (moduleId == "GIACS170") { // added by shan
																// 06.18.2013
							showAdvancedPremiumPaymentPage();
						} else if (moduleId == "GIACS147") { // added by
																// Kenneth L.
																// 06.25.2013
							showPremiumDepositMainPage();
						} else if (moduleId == "GIACS078") { // added by shan
																// 06.25.2013
							showCollectionAnalysisPage();
						} else if (moduleId == "GIACS273") { // added by shan
																// 06.27.2013
							showDisbursementListPage();
						} else if (moduleId == "GIACS071") {
							showMemoPage();
						}else if (moduleId == "GIACS231") {	//added by Gzelle 09.11.2013
							showTransactionStatus();
						} else if(moduleId == "GIACS503"){
							showTrialBalancePerSL();
						}
					} else {
						showMessageBox(
								"You are not allowed to access this module.",
								"E");
					}
				}
			}
		});
	} catch (e) {
		showErrorMessage("checkUserAccessGiacs", e);
	}
}