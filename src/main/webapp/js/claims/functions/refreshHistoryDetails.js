function refreshHistoryDetails(){
	try{
		var dummy = new Object();
		retrieveClmLossExpense(objCurrGICLLossExpPayees);
		retrieveLossExpDetail(dummy);
		
		populateClmLossExpForm(null);
		populateLossExpDtlForm(null);
		$("txtHistSeqNo").value = lpad(getNextHistSeqNo(), 3, "0");
		$("totalLossAmt").value = formatCurrency(0);
		$("totalAmtLessDed").value = formatCurrency(0);
		
		disableButton("btnDistDate");
		disableButton("btnDistribute");
		disableButton("btnNegate");
		disableButton("btnLossTax");
		disableButton("btnBillInfo");
		disableButton("btnCancelHistory");
		
		$("distDetailsDiv").hide();
		$("distDetailsMainDiv").hide();
		$("distDtlGro").innerHTML = "Show";
		$("historyDetailsMainDiv").scrollIntoView();
		
		if(nvl(fromClaimMenu, "N") == "N"){
			getClaimsMenuProperties(true);
		}
		
	}catch (e) {
		showErroMessage("refreshHistoryDetails", e);
	}
}