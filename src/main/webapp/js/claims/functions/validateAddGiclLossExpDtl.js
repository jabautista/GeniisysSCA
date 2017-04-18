function validateAddGiclLossExpDtl(){
	if(objCurrGICLItemPeril == null){
		showMessageBox("Please select an item first.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees == null){
		showMessageBox("Please select a payee first.", "I");
		return false;
	}else if(objCurrGICLClmLossExpense == null){
		showMessageBox("Please select a history record first.", "I");
		return false;
	}else if($("txtLoss").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtLoss");
		return false;
	}else if($("txtBaseAmt").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtBaseAmt");
		return false;
	//}else if(parseInt($("txtBaseAmt").value) == 0){ --comment out by Aliza G. SR 21464 01.27.2016
	}else if(parseFloat($("txtBaseAmt").value) < 0.01){ //added by Aliza G. SR 21464 01.27.2016
		customShowMessageBox("Base Amount cannot be zero.", "I", "txtBaseAmt");
		$("txtBaseAmt").value = "";
		return false;
	}else if($("txtUnits").value == ""){
		customShowMessageBox("Please enter number of units.", "I", "txtUnits");
		return false;
	}else if(parseInt($("txtUnits").value) < 1){
		customShowMessageBox("Number of units cannot be zero.", "I", "txtUnits");
		$("txtUnits").value = 1;
		return false;
	}else if((parseFloat(getTotalLossAmtOfLossExpDtl(unformatCurrencyValue($("txtLossAmt").value))) > parseFloat(nvl(objCurrGICLItemPeril.annTsiAmt, 0))) && objCurrGICLLossExpPayees.payeeType == "L"){
		customShowMessageBox("Total losses should not be greater than TSI Amount.", "I", "txtBaseAmt");
		return false;
	}
	return true;
}