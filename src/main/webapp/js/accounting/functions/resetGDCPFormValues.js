function resetGDCPFormValues(){
	$("tranType").selectedIndex = 0;
	$("tranSource").selectedIndex = 0;
	$("billCmNo").value = null;
	$("instNo").value = null;
	$("premCollectionAmt").value = formatCurrency(0);
	$("directPremAmt").value = formatCurrency(0);
	$("taxAmt").value = formatCurrency(0);
	$("assdName").value = null;
	$("polEndtNo").value = null;
	$("particulars").value = null;
	objAC.currentRecord = {};
	disableButton("btnForeignCurrency");
}