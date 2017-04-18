function validateAddLossExpDeductible(){
	if(hasPendingLossExpDeductibleRecords()){
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}else if($("txtLossExpCd").value == ""){
		customShowMessageBox("Please enter Loss Expense.", "I", "txtLossExpCd");
		return false;
	}else if($("txtDedLossExpCd").value == ""){
		customShowMessageBox("Loss/es to which the deductible applies cannot be null.", "I", "txtDedLossExpCd");
		return false;
	}else if(nvl($("txtDedUnits").value, 0) == 0){
		customShowMessageBox("Number of units cannot be zero.", "I", "txtDedUnits");
		return false;
	//}else if($("txtDedBaseAmt").value == ""){
	}else if($("txtDedBaseAmt").value == "" && dedBaseAmtRequired == "Y"){
		customShowMessageBox("Please enter base amount.", "I", "txtDedBaseAmt");
		return false;
	}else if($("txtDeductibleAmt").value == ""){
		customShowMessageBox("Please enter deductible amount.", "I", "txtDeductibleAmt");
		return false;
	}else if(parseFloat(getTotalLossExpDeductibleAmt(unformatCurrencyValue($("txtDeductibleAmt").value))) > parseFloat(nvl(objCurrGICLItemPeril.annTsiAmt, 0))){
		customShowMessageBox("Total loss amount should not be greater than the TSI Amount.", "I", "txtDeductibleAmt");
		return false;
	}else if((nvl($("txtDedRate").value, 0) == 0) && (nvl($("hidDedType").value, "") != "F")){ //added by : Kenneth : 07.10.2015 : SR 3637
		customShowMessageBox("Deductible Rate cannot be zero.", "I", "txtDedRate");
		return false;
	}
	return true;
}