function computeTotalTaxAmount(){
	var totalTaxAmt = 0;
	
	for(var i=0; i<objGICLLossExpTax.length; i++){
		if(objGICLLossExpTax[i].recordStatus != -1){
			totalTaxAmt = parseFloat(nvl(totalTaxAmt,0)) + parseFloat(nvl(objGICLLossExpTax[i].taxAmt, 0));
		}
	}
	
	$("totalTaxAmt").value = formatCurrency(totalTaxAmt);
}