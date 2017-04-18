/**
 * Validate direct claim payment to be added
 * @return true - proceed
 */
function isDirectClaimPaymentValid(){
	var proceed = true;
	if($("selTransactionType").selectedIndex == 0 ){
		showMessageBox("Transaction Type not selected", imgMessage.ERROR);
		proceed = false;
	}else if($F("txtAdviceSequence").blank()){
		showMessageBox("Advice Number not selected", imgMessage.ERROR);
		proceed = false;
	}/*else if($("selPayeeClass").selectedIndex == 0 ){
		showMessageBox("Payee class not selected", imgMessage.ERROR);
		proceed = false;
	}*/else if($F("txtPeril").blank()){
		showMessageBox("Peril code not entered", imgMessage.ERROR);
		proceed = false;
	}else if($F("txtDisbursementAmount").blank()){
		showMessageBox("Please enter disbursement amount", imgMessage.ERROR);
		proceed = false;
	}else if($F("txtNetDisbursement").blank()){
		showMessageBox("Please enter the net disubursement amount.", imgMessage.ERROR);
		proceed = false;
	}else if($F("selPayeeClass2").blank()) {
		showMessageBox("Payee class not selected", imgMessage.ERROR);
		proceed = false;
	}
	return proceed;
}