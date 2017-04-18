function clearInvalidPrem(){
	$("billCmNo").value = null;
	$("instNo").value = null;
	$("premCollectionAmt").value = formatCurrency(0);
	$("directPremAmt").value = formatCurrency(0);
	$("taxAmt").value = formatCurrency(0);
	$("assdName").value = null;
	$("polEndtNo").value = null;
	$("particulars").value = null;
}