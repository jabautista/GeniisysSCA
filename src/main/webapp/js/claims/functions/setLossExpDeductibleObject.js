function setLossExpDeductibleObject(){
	var leDeductible = new Object();
	
	leDeductible.claimId		 = objCLMGlobal.claimId;
	leDeductible.clmLossId 		 = objCurrGICLClmLossExpense.claimLossId;
	leDeductible.lossExpCd 		 = escapeHTML2($("txtLossExpCd").getAttribute("lossExpCd"));
	leDeductible.dspExpDesc 	 = escapeHTML2($("txtLossExpCd").value);
	leDeductible.nbtNoOfUnits	 = unformatCurrencyValue($("txtDedUnits").value);
	leDeductible.dedBaseAmt		 = unformatCurrencyValue($("txtDedBaseAmt").value);
	leDeductible.dtlAmt			 = unformatCurrencyValue($("txtDeductibleAmt").value);
	leDeductible.lineCd		     = objCLMGlobal.lineCode;
	leDeductible.lossExpType     = objCurrGICLLossExpPayees.payeeType;
	leDeductible.originalSw		 = escapeHTML2($("hidDedOriginalSw").value);
	leDeductible.sublineCd		 = escapeHTML2($("hidDedSublineCd").value);
	leDeductible.dedLossExpCd	 = escapeHTML2($("txtDedLossExpCd").getAttribute("dedLossExpCd"));
	leDeductible.dspDedLeDesc	 = escapeHTML2($("txtDedLossExpCd").value);
	leDeductible.dedRate		 = parseFloat(nvl($("txtDedRate").value, 0));
	leDeductible.strDedRate		 = parseFloat(nvl($("txtDedRate").value, 0));//added by : Kenneth : 07.10.2015 : SR 4204
	leDeductible.deductibleText  = escapeHTML2($("txtDeductibleText").value);
	leDeductible.nbtDedType 	 = escapeHTML2($("txtDeductibleType").value);
	leDeductible.nbtDeductibleType = escapeHTML2($("hidDedType").value);
	leDeductible.nbtCompSw		 = escapeHTML2($("hidDedCompSw").value);
	leDeductible.aggregateSw	 = escapeHTML2($("hidDedAggregateSw").value);
	leDeductible.ceilingSw		 = escapeHTML2($("hidDedCeilingSw").value);
	leDeductible.nbtMinAmt		 = $("hidDedMinAmt").value;
	leDeductible.nbtMaxAmt		 = $("hidDedMaxAmt").value;
	leDeductible.nbtRangeSw		 = escapeHTML2($("hidDedRangeSw").value);
	return leDeductible;
}