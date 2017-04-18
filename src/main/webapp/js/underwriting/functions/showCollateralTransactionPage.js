function showCollateralTransactionPage(){ //  rmanalad 4.13.2011
	new Ajax.Updater("parInfoDiv", contextPath+"/GIPIWCollateralTransactionController?action=showCollateralTransactionPage&parId="+$F("globalParId"),{
		method: "POST",
		evalScripts: true,
		asynchronous: true,
		onCreate: showNotice("Getting Collateral Transaction, please wait..."),
		onComplete: function () {
			try {
				hideNotice("");
				setDocumentTitle("Collateral Transaction");			
			} catch (e) {
				showErrorMessage("showColalteralTransactionPage", e);
			}
		}
	});	
}