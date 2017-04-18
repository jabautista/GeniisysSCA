function showPremDep() {
	new Ajax.Updater("transBasicInfoSubpage", contextPath
			+ "/GIACPremDepositController?action=showPremDep", {
		method : "GET",
		parameters : {
			gaccTranId : objACGlobal.gaccTranId,
			gaccBranchCd : objACGlobal.branchCd,
			gaccFundCd : objACGlobal.fundCd,
			tranSource : objACGlobal.tranSource,
			orFlag : objACGlobal.orFlag
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
}