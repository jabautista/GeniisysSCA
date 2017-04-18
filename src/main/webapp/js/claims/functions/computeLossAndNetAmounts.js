function computeLossAndNetAmounts(){
	var lossAmt = 0;
	var amtLessDed = 0;
	lossAmt = parseInt(nvl($("txtUnits").value, 0)) * parseFloat(nvl(unformatCurrencyValue($("txtBaseAmt").value), 0));
	amtLessDed = lossAmt;
	$("txtLossAmt").value = formatCurrency(lossAmt);
	$("txtAmtLessDed").value = formatCurrency(amtLessDed);
}