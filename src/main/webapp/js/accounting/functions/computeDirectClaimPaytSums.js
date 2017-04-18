function computeDirectClaimPaytSums(objArray){
	var totalInputVat = 0;
	var totalWhTax = 0;
	var totalNetDisbursement = 0;
	var inputVatAmt	= 0;
	var wholdingTax = 0;
	var netDisbursementAmt = 0;
	var temp = parseInt(0);
	
	for(var i = 0; i < objArray.length; i++){
		if(objArray[i].recordStatus != -1){
			temp = 0;	temp = parseFloat(objArray[i].inputVatAmount);
			totalInputVat = totalInputVat + temp;
			
			temp = 0;	temp = parseFloat(objArray[i].withholdingTaxAmount);
			totalWhTax = totalWhTax + temp;
			
			temp = 0;	temp = parseFloat(objArray[i].netDisbursementAmount);
			totalNetDisbursement = totalNetDisbursement + temp;
		}
	}
	$("totalInputVatAmount").value = totalInputVat;
	$("totalWithholdingTaxAmount").value = totalWhTax;
	$("totalNetDisbursementAmount").value = totalNetDisbursement;
	$("lblTotalNetDisbursement").innerHTML = formatCurrency(totalNetDisbursement);
}