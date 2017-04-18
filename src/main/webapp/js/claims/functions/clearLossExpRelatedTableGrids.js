function clearLossExpRelatedTableGrids(){
	try{
		populatePayeeForm(null);
		populateClmLossExpForm(null);
		populateLossExpDtlForm(null);
		$("totalLossAmt").value = formatCurrency(0);
		$("totalAmtLessDed").value = formatCurrency(0);
		
		if($("payeeDetailsTableGrid") != null){
			clearTableGridDetails(giclLossExpPayeesTableGrid);
		}
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
		$("distDetailsDiv").hide();
		$("distDetailsMainDiv").hide();
		$("distDtlGro").innerHTML = "Show";
		
	}catch(e){
		showErrorMessage("clearLossExpRelatedTableGrids", e);
	}
}