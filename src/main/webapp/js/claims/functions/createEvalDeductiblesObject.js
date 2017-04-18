function createEvalDeductiblesObject(){
	var newDed = new Object();
	
	newDed.evalId 	   = selectedMcEvalObj.evalId;
	newDed.dedCd       = escapeHTML2($("txtEvalDedCd").getAttribute("dedCd"));
	newDed.dspExpDesc  = escapeHTML2($("txtEvalDedCd").value);
	newDed.sublineCd   = escapeHTML2($("hidEvalDedSublineCd").value);
	newDed.noOfUnit    = unformatNumber(nvl($("txtEvalDedUnits").value, 1));
	newDed.dedBaseAmt  = unformatCurrencyValue(nvl($("txtEvalDedBaseAmt").value, 0));
	newDed.dedAmt      = unformatCurrencyValue($("txtEvalDedAmt").value);
	newDed.dedRate     = parseFloat(nvl($("txtEvalDedRate").value, 0));
	newDed.dedText     = escapeHTML2($("txtEvalDedText").value);
	newDed.payeeTypeCd = escapeHTML2($("txtEvalDedCompany").getAttribute("payeeTypeCd"));
	newDed.payeeCd 	   = escapeHTML2($("txtEvalDedCompany").getAttribute("payeeCd"));
	newDed.dspCompanyDesc = escapeHTML2($("txtEvalDedCompany").value);
	newDed.netTag 	   = escapeHTML2($("hidEvalDedNetTag").value);
	
	return newDed;
}