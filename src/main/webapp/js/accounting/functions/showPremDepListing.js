function showPremDepListing() {
	try {
		new Ajax.Updater("transBasicInfoSubpage", contextPath
				+ "/GIACPremDepositController?action=showPremDepListing", {
			method : "GET",
			parameters : {
				moduleId : 'GIACS026',
				gaccTranId : objACGlobal.gaccTranId,
				gaccBranchCd : objACGlobal.branchCd,
				gaccFundCd : objACGlobal.fundCd,
				orFlag : objACGlobal.orFlag
			/*
			 * , tranSource : objACGlobal.tranSource,
			 */
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading Premium Deposit page. Please wait...");
			},
			onComplete : function() {
				hideNotice("");
			}
		});
	} catch (e) {
		showMessageBox("showPremDepListing", e);
	}
}