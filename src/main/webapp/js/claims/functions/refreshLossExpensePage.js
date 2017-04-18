function refreshLossExpensePage(){
	try{
		hideNotice();
		objCurrGICLLossExpPayees = null;
		objCurrGICLClmLossExpense = null;
		objCurrGICLLossExpDtl = null;
		objCurrGICLLossExpDs = null;
		objCurrLossExpDeductibles = null;
		
		var dummy = new Object();
		
		if(objCurrGICLItemPeril == null){ // to handle null value of objCurrGICLItemPeril - Nica 07.16.2012
			objCurrGICLItemPeril = new Object();
		}
		
		retrievePayeeDetails(objCurrGICLItemPeril);
		retrieveClmLossExpense(dummy);
		retrieveLossExpDetail(dummy);
		populatePayeeForm(null);
		populateClmLossExpForm(null);
		populateLossExpDtlForm(null);
		
		$("totalLossAmt").value = formatCurrency(0);
		$("totalAmtLessDed").value = formatCurrency(0);
		disableButton("btnViewHistory");
		disableButton("btnCopyClmLossExp");
		$("distDetailsDiv").hide();
		$("distDetailsMainDiv").hide();
		$("distDtlGro").innerHTML = "Show";
		$("historyDetailsMainDiv").scrollIntoView();
		
		if(nvl(fromClaimMenu, "N") == "N"){
			getClaimsMenuProperties(true);
		}
		
	}catch (e) {
		showErroMessage("refreshLossExpensePage", e);
	}
}