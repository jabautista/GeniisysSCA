function showMemoPage() {
	var action = (objAC.fromMenu == "menuAddCreditDebitMemo" || objAC.fromMenu == "tblAddCreditDebitMemo") ? "showAddCreditDebitMemoPage"
			: "getMemoList";
	var cancelFlag = objAC.fromMenu == "menuCancelCreditDebitMemo" ? "Y" : "N";

	try {
		objACGlobal.gaccTranId = null;

		new Ajax.Request(contextPath + "/GIACMemoController", {
			parameters : {
				action : action,
				cancelFlag : cancelFlag,
				gaccTranId : 0,
				tranStatus : "O", //Added by Jerome Bautista 12.14.2015 SR 3467
				moduleId : "GIACS071"
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : function() {
				showNotice("Loading Credit/Debit Memo, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				$("mainContents").update(response.responseText);
				hideAccountingMainMenus();
			}
		});
	} catch (e) {
		showErrorMessage("showCreditDebitMemoPage", e);
	}
}