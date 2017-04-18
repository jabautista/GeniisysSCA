//new version
function computeTotalAmountsGIACS7(collnAmt, premAmt, taxAmt, op){
	var totalCollnAmt = unformatCurrency("txtTotalCollAmt");
	var totalPremAmt = unformatCurrency("txtTotalPremAmt");
	var totalTaxAmt = unformatCurrency("txtTotalTaxAmt");
	
	collnAmt = collnAmt == null ? unformatCurrency("premCollectionAmt") : collnAmt;
	premAmt = premAmt == null ? unformatCurrency("directPremAmt") : premAmt;
	taxAmt = taxAmt == null ? unformatCurrency("taxAmt") : taxAmt;
	
	var prevCollnAmt = nvl(objAC.selectedRecord.collAmt, 0);
	var prevPremAmt = nvl(objAC.selectedRecord.premAmt, 0);
	var prevTaxAmt = nvl(objAC.selectedRecord.taxAmt, 0);
	
	if(op=="del") {
		totalCollnAmt = totalCollnAmt - collnAmt;
		totalPremAmt = totalPremAmt - premAmt;
		totalTaxAmt = totalTaxAmt - taxAmt;
	} else {
		totalCollnAmt = totalCollnAmt - prevCollnAmt + collnAmt;
		totalPremAmt = totalPremAmt - prevPremAmt + premAmt;
		totalTaxAmt = totalTaxAmt - prevTaxAmt + taxAmt;
	}
	
	$("txtTotalCollAmt").value = formatCurrency(totalCollnAmt);
	$("txtTotalPremAmt").value = formatCurrency(totalPremAmt);
	$("txtTotalTaxAmt").value = formatCurrency(totalTaxAmt);
}