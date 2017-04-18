function populateEvalDeductible(ded){
	
	$("txtEvalDedCd").value 		= ded == null ? "" : unescapeHTML2(ded.dspExpDesc);
	$("txtEvalDedCd").setAttribute("dedCd", ded == null ? "" : ded.dedCd);
	$("txtEvalDedUnits").value 		= ded == null ? "" : ded.noOfUnit;
	$("txtEvalDedCompany").value 	= ded == null ? "" : unescapeHTML2(ded.dspCompanyDesc);
	$("txtEvalDedCompany").setAttribute("payeeCd", ded == null ? "" : ded.payeeCd);
	$("txtEvalDedCompany").setAttribute("payeeTypeCd", ded == null ? "" : ded.payeeTypeCd);
	$("txtEvalDedRate").value 		= ded == null ? "" : formatToNineDecimal(nvl(ded.dedRate, 0));
	$("txtEvalDedBaseAmt").value 	= ded == null ? "" : formatCurrency(ded.dedBaseAmt);
	$("txtEvalDedAmt").value 		= ded == null ? "" : formatCurrency(ded.dedAmt);
	$("txtEvalDedText").value 		= ded == null ? "" : unescapeHTML2(ded.dedText);
	$("hidEvalDedSublineCd").value 	= ded == null ? "" : ded.sublineCd;
	$("hidEvalDedNetTag").value 	= ded == null ? "" : ded.netTag;
	
	$("btnAddEvalDeductible").value = ded == null ? "Add" : "Update";
	
	(ded == null ? disableButton($("btnDeleteEvalDeductible")) : enableButton($("btnDeleteEvalDeductible")));
	
	if(ded==null){
		$("txtEvalDedRate").readOnly = false;
		$("txtEvalDedBaseAmt").readOnly = false;
	}else{
		if(nvl(ded.sublineCd, "") != ""){
			$("txtEvalDedRate").readOnly = true;
			$("txtEvalDedBaseAmt").readOnly = true;
		}else{
			$("txtEvalDedRate").readOnly = false;
			$("txtEvalDedBaseAmt").readOnly = false;
		}
	}
	if( variablesObj.evalStatCd == 'CC' || variablesObj.evalStatCd == 'PD'){
		disableButton($("btnDeleteEvalDeductible"));
	}	
}