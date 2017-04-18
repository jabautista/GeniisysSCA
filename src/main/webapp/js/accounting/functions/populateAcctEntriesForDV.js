function populateAcctEntriesForDV() {
	try {
		$("fundCd").value = objACGlobal.fundCd;
		$("branch").value = objACGlobal.branchCd;
		$("transactionNo").value = objGIACS002.tranNo;
		$("orNo").value = objGIACS002.dvNo;
		$("orStatus").value = objGIACS002.dvStatus;
		$("orDate").value = objGIACS002.dvDate;
		$("grossAmtCurrency").value = objGIACS002.foreignCurrency;
		$("grossAmt").value = objGIACS002.foreignAmount;
		$("payor").value = unescapeHTML2(objGIACS002.payee);
		$("fCurrency").value = objGIACS002.localCurrency;
		$("fCurrencyAmt").value = objGIACS002.localAmount;
		$("lblOrNo").value = "DV No:";
		$("lblOrNo").innerHTML = "DV No:";
		$("lblOrNo").title = "DV No:";
		$("lblOrStatus").innerHTML = "DV Status:";
		$("lblOrStatus").title = "DV Status:";
		$("lblOrDate").innerHTML = "DV Date:";
		$("lblOrDate").title = "DV Date:";
	} catch (e) {
		showErrorMessage("populateAcctEntriesForDV", e);
	}
}