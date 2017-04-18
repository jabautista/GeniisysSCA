function computeDeductibles() {
	// $("localCurrAmt").value =
	// formatCurrency((unformatCurrency("origlocalCurrAmt") -
	// unformatCurrency("deductionComm")) - unformatCurrency("vatAmount"));
	$("localCurrAmt").value = formatCurrency(((unformatCurrency("grossAmt")) - unformatCurrency("deductionComm"))
			- unformatCurrency("vatAmount"));
	// $("fcNetAmt").value = formatCurrency((Math.round((
	// unformatCurrency("origlocalCurrAmt") /
	// parseFloat($F("currRt")))*100)/100) - unformatCurrency("fcCommAmt") -
	// unformatCurrency("fcTaxAmt"));
	$("fcNetAmt").value = formatCurrency((Math
			.round((unformatCurrency("grossAmt") / parseFloat($F("currRt"))) * 100) / 100)
			- unformatCurrency("fcCommAmt") - unformatCurrency("fcTaxAmt"));
}