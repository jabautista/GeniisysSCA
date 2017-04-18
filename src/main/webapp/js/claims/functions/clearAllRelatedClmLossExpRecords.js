function clearAllRelatedClmLossExpRecords(){
	objCurrGICLClmLossExpense = null;
	giclClmLossExpenseTableGrid.releaseKeys();
	populateClmLossExpForm(null);
	populateLossExpDtlForm(null);
	$("txtHistSeqNo").value = lpad(getNextHistSeqNo(), 3, "0");
	$("totalLossAmt").value = formatCurrency(0);
	$("totalAmtLessDed").value = formatCurrency(0);
	
	if($("giclLossExpDtlTableGrid") != null){
		clearTableGridDetails(giclLossExpDtlTableGrid);
	}
	if($("giclLossExpDsTableGrid") != null){
		clearTableGridDetails(giclLossExpDsTableGrid);
	}
	if($("giclLossExpRidsTableGrid") != null){
		clearTableGridDetails(giclLossExpRidsTableGrid);
	}
	
	disableButton("btnDistDate");
	disableButton("btnDistribute");
	disableButton("btnNegate");
	disableButton("btnLossTax");
	disableButton("btnBillInfo");
	disableButton("btnCancelHistory");
	
	$("distDetailsDiv").hide();
	$("distDetailsMainDiv").hide();
	$("distDtlGro").innerHTML = "Show";
}