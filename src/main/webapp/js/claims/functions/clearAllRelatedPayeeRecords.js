function clearAllRelatedPayeeRecords(){
	objCurrGICLLossExpPayees = null;
	giclLossExpPayeesTableGrid.releaseKeys();
	populatePayeeForm(null);
	populateClmLossExpForm(null);
	populateLossExpDtlForm(null);
	$("totalLossAmt").value = formatCurrency(0);
	$("totalAmtLessDed").value = formatCurrency(0);
	isGiclMortgExist = $("hidMortgExist").value;
	
	if($("clmLossExpTableGrid") != null){
		clearTableGridDetails(giclClmLossExpenseTableGrid);
	}
	if($("giclLossExpDtlTableGrid") != null){
		clearTableGridDetails(giclLossExpDtlTableGrid);
	}
	if($("giclLossExpDsTableGrid") != null){
		clearTableGridDetails(giclLossExpDsTableGrid);
	}
	if($("giclLossExpRidsTableGrid") != null){
		clearTableGridDetails(giclLossExpRidsTableGrid);
	}

	disableButton("btnViewHistory");
	disableButton("btnCopyClmLossExp");
	$("distDetailsDiv").hide();
	$("distDetailsMainDiv").hide();
	$("distDtlGro").innerHTML = "Show";
}