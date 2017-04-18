function checkClmLossExpForUpdate(giclClmLossExp){
	distSw = 'N';  // nante 11/7/2013
	if(giclClmLossExp == null){
		enableDisableClmLossExpForm("enable");
		enableDisableLossExpDtlForm("enable");
		return true;
	}else if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("Record cannot be updated. Loss for this peril has been closed/withdrawn/denied.", "I");
		enableDisableClmLossExpForm("disable");
		enableDisableLossExpDtlForm("disable");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("Record cannot be updated. Expense for this peril has been closed/withdrawn/denied.", "I");
		enableDisableClmLossExpForm("disable");
		enableDisableLossExpDtlForm("disable");
		return false;
	}else if(nvl(giclClmLossExp.distSw, "N") == "Y"){
		distSw = giclClmLossExp.distSw;   //nante 11/7/2013
		//showMessageBox("You cannot update this record, distribution has been made.", "I");   //nante 11/7/2013
		enableDisableClmLossExpForm("disable");
		enableDisableLossExpDtlForm("disable");
		return false;
	/*}else if(nvl(giclClmLossExp.withEvalPayment, "N") == "Y" && $("hidEnableUpdSetHist").value != "Y"){
		showMessageBox("You cannot update this record, this was created using motorcar evaluation report.", "I");
		enableDisableClmLossExpForm("disable");
		enableDisableLossExpDtlForm("disable");
		return false;*/ // commented by: Nica 04.09.2013
	}else if(nvl(giclClmLossExp.withEvalPayment, "N") == "Y" && $("hidEnableUpdSetHist").value != "Y"){
		enableDisableClmLossExpForm("enable");
		$("txtHistSeqNo").readOnly = true;
		disableButton("btnDeleteClmLossExp");
		$("hrefHistStatus").hide();
		enableDisableLossExpDtlForm("disable");
		return false;
	}else{
		enableDisableClmLossExpForm("enable");
		enableDisableLossExpDtlForm("enable");
		return true;
	}
}