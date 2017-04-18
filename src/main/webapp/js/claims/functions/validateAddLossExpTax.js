function validateAddLossExpTax(){
	if(hasPendingLossExpTaxRecords()){
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}else if($("selTaxType").value == ""){
		customShowMessageBox("Please enter Tax Type.", "I", "selTaxType");
		return false;
	}else if($("txtTaxCd").value == ""){
		customShowMessageBox("Please enter Tax Code.", "I", "txtTaxCd");
		return false;
	}else if($("txtSLCode").value == "" && $("slCodeDiv").hasClassName("required")){
		customShowMessageBox("Please enter SL Code.", "I", "txtSLCode");
		return false;
	}else if($("txtTaxLossExpCd").value == ""){
		customShowMessageBox("Please enter Loss/Expense.", "I", "txtSLCode");
		return false;
	}else if($("txtTaxBaseAmt").value == ""){
		customShowMessageBox("Please enter Base Amount.", "I", "txtTaxBaseAmt");
		return false;
	}else if($("txtTaxPct").value == ""){
		customShowMessageBox("Please enter Tax Percentage.", "I", "txtTaxPct");
		return false;
	}else if($("txtTaxAmt").value == ""){
		customShowMessageBox("Please enter Tax Amount.", "I", "txtTaxAmt");
		return false;
	}else if(changeTag == 1){ //Added by Kenneth 05.26.2015
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}
	return true;
}