function onSelectMcEvalDeductible(ded){
	$("txtEvalDedCd").value 		= unescapeHTML2(ded.lossExpDesc);
	$("txtEvalDedCd").setAttribute("dedCd", ded.lossExpCd);
	$("txtEvalDedUnits").value 		= nvl($("txtEvalDedUnits").value, 1);
	$("txtEvalDedRate").value 		= formatToNineDecimal(nvl(ded.dedRate, 0));
	$("txtEvalDedBaseAmt").value 	= formatCurrency(ded.amount);
	$("txtEvalDedText").value 		= unescapeHTML2(ded.dedText);
	$("hidEvalDedSublineCd").value 	= ded.sublineCd;
	computeEvalDeductibleAmount();
	
	if(nvl(ded.sublineCd, "") != ""){
		$("txtEvalDedRate").readOnly = true;
		$("txtEvalDedBaseAmt").readOnly = true;
	}else{
		$("txtEvalDedRate").readOnly = false;
		$("txtEvalDedBaseAmt").readOnly = false;
	}
}