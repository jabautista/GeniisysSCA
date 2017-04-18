function computeTaxAmount(){
	var taxType = $("selTaxType").value;
	var baseAmt = unformatCurrencyValue(nvl($("txtTaxBaseAmt").value, 0));
	var taxPct = parseFloat(nvl($("txtTaxPct").value, 0));
	var wTax = nvl($("hidWTax").value, "N");
	var taxAmt = 0;
	
	if(taxType == "I"){
		if(wTax == "Y"){
			taxAmt = baseAmt - (baseAmt /(1+(taxPct/100)));
		}else{
			taxAmt = baseAmt * (taxPct/100);
		}
	}else{
		taxAmt = baseAmt * (taxPct/100);
	}
	$("txtTaxAmt").value = formatCurrency(taxAmt);
}