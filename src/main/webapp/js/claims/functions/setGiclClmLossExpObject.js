function setGiclClmLossExpObject(){
	var giclLossExp = new Object();
	
	giclLossExp.claimId 		= objCLMGlobal.claimId;
	giclLossExp.claimLossId 	= $("hidClmLossId").value;
	giclLossExp.historySequenceNumber = removeLeadingZero($("txtHistSeqNo").value);
	giclLossExp.itemNo 			= objCurrGICLItemPeril.itemNo; 
	giclLossExp.perilCode 		= objCurrGICLItemPeril.perilCd;
	giclLossExp.groupedItemNo 	= objCurrGICLItemPeril.groupedItemNo;
	giclLossExp.claimClmntNo 	= objCurrGICLLossExpPayees.clmClmntNo;
	giclLossExp.itemStatusCd 	= escapeHTML2($("txtHistStatus").getAttribute("histStatus"));
	giclLossExp.clmLossExpStatDesc = escapeHTML2($("txtHistStatus").value);
	giclLossExp.payeeType 		= objCurrGICLLossExpPayees.payeeType;
	giclLossExp.payeeCode 		= objCurrGICLLossExpPayees.payeeCd;
	giclLossExp.payeeClassCode 	= objCurrGICLLossExpPayees.payeeClassCd;
	giclLossExp.exGratiaSw		= $("chkExGratia").checked ? "Y" : "N";
	//giclLossExp.distSw	    = escapeHTML2($("hidDistSw").value);  //commented by: nante 11/7/2013
	giclLossExp.distSw			= distSw;   //nante 11/7/2013
	giclLossExp.cancelSw		= escapeHTML2($("hidCancelSw").value);
	giclLossExp.paidAmount		= unformatCurrencyValue($("txtLossPaidAmt").value);
	giclLossExp.netAmount		= unformatCurrencyValue($("txtLossNetAmt").value);
	giclLossExp.adviceAmount	= unformatCurrencyValue($("txtLossAdviceAmt").value);
	giclLossExp.remarks			= $("txtRemarks").value;
	giclLossExp.finalTag		= $("chkFinalTag").checked ? "Y" : "N";
	giclLossExp.withLossExpDtl	= escapeHTML2($("hidWithLossExpDtl").value);
	
	return giclLossExp;
}