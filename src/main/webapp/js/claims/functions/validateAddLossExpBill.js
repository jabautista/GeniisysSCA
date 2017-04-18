function validateAddLossExpBill(){
	if($("selDocType").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "selDocType");
		return false;
	}else if($("txtBillPayeeClassCd").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtBillPayeeClassCd");
		return false;
	}else if($("txtBillPayeeCd").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtBillPayeeCd");
		return false;
	}else if($("txtDocNumber").value == ""){
		customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtDocNumber");
		return false;
	}
	return true;
}