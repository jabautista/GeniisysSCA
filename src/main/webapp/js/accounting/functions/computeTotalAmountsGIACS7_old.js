// moved here from searchInvoiceInstNo/directPremiumCollection2
function computeTotalAmountsGIACS7_old(){
	var totalCollAmt = 0;
	var totalPremAmt = 0;
	var totalTaxAmt = 0;
	for(var i = 0; i < objAC.objGdpc.length; i++){
		if(objAC.objGdpc[i].recordStatus != -1){
			totalCollAmt += parseFloat(objAC.objGdpc[i].collAmt);
			totalPremAmt += parseFloat(objAC.objGdpc[i].premAmt);
			totalTaxAmt += parseFloat(objAC.objGdpc[i].taxAmt);
		}
	}
	$("txtTotalCollAmt").value = formatCurrency(totalCollAmt);
	$("txtTotalPremAmt").value = formatCurrency(totalPremAmt);
	$("txtTotalTaxAmt").value = formatCurrency(totalTaxAmt);
}