function setGiclLossExpDtlObject(){
	var giclLossExpDtl = new Object();
	
	giclLossExpDtl.claimId		= objCLMGlobal.claimId;
	giclLossExpDtl.clmLossId    = objCurrGICLClmLossExpense.claimLossId;
	giclLossExpDtl.lineCd		= objCLMGlobal.lineCd;
	giclLossExpDtl.lossExpCd	= escapeHTML2($("txtLoss").getAttribute("lossExpCd"));
	giclLossExpDtl.dspExpDesc	= escapeHTML2($("txtLoss").value);
	giclLossExpDtl.noOfUnits	= parseInt($("txtUnits").value);
	giclLossExpDtl.nbtNoOfUnits = parseInt($("txtUnits").value);
	giclLossExpDtl.dedBaseAmt   = unformatCurrencyValue($("txtBaseAmt").value);
	giclLossExpDtl.dtlAmt		= unformatCurrencyValue($("txtLossAmt").value);
	giclLossExpDtl.sublineCd	= $("hidSublineCd").value;
	giclLossExpDtl.lossExpClass = $("hidLossExpClass").value;
	giclLossExpDtl.originalSw   = $("chkOriginalSw").checked ? "Y" : "N";
	giclLossExpDtl.withTax		= $("chkWithTax").checked ? "Y" : "N";
	giclLossExpDtl.nbtNetAmt	= unformatCurrencyValue($("txtAmtLessDed").value);
	giclLossExpDtl.lossExpType	= objCurrGICLLossExpPayees.payeeType;
	giclLossExpDtl.nbtCompSw	= escapeHTML2($("hidNbtCompSw").value);
	
	return giclLossExpDtl;
}