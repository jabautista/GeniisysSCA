function setLossExpTaxObject(){
	var newTax = new Object();
	
	newTax.claimId   = objCLMGlobal.claimId;
	newTax.clmLossId = objCurrGICLClmLossExpense.claimLossId;
	newTax.taxId	 = $("hidTaxId").value;
	newTax.taxCd     = removeLeadingZero($("txtTaxCd").getAttribute("taxCd"));
	newTax.taxName	 = escapeHTML2($("txtTaxCd").value);
	newTax.taxType   = escapeHTML2($("selTaxType").value);
	newTax.lossExpCd = $("txtTaxLossExpCd").getAttribute("lossExpCd");
	newTax.baseAmt   = unformatCurrencyValue($("txtTaxBaseAmt").value);
	newTax.taxPct    = parseFloat($("txtTaxPct").value);
	newTax.taxAmt    = unformatCurrencyValue($("txtTaxAmt").value);
	newTax.advTag    = escapeHTML2($("hidAdvTag").value);
	newTax.netTag	 = escapeHTML2($("hidNetTag").value);
	newTax.withTax	 = escapeHTML2($("hidWTax").value);
	newTax.slTypeCd  = escapeHTML2($("hidSlTypeCd").value);
	newTax.slCd		 = $("txtSLCode").value;
	return newTax;
}