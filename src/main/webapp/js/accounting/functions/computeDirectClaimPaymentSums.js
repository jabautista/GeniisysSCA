/**
 * Computes the sum of the ff: - GIACS017 - Input Vat Amount - Withholding Tax -
 * Net Disbursement Amount
 * 
 * @author rencela
 */
function computeDirectClaimPaymentSums(){
	var totalInputVat = 0;
	var totalWhTax = 0;
	var totalNetDisbursement = 0;
	var inputVatAmt	= 0;
	var wholdingTax = 0;
	var netDisbursementAmt = 0;
	var temp = parseInt(0);
	
	for(var i = 0; i < dcpJsonObjectList.length; i++){
		if(dcpJsonObjectList[i].recordStatus != -1){
			temp = 0;	temp = parseFloat(dcpJsonObjectList[i].inputVatAmount);
			totalInputVat = totalInputVat + temp;
			
			temp = 0;	temp = parseFloat(dcpJsonObjectList[i].withholdingTaxAmount);
			totalWhTax = totalWhTax + temp;
			
			temp = 0;	temp = parseFloat(dcpJsonObjectList[i].netDisbursementAmount);
			totalNetDisbursement = totalNetDisbursement + temp;
		}
	}
	$("totalInputVatAmount").value = totalInputVat;
	$("totalWithholdingTaxAmount").value = totalWhTax;
	$("totalNetDisbursementAmount").value = totalNetDisbursement;
	$("lblTotalNetDisbursement").innerHTML = formatCurrency(totalNetDisbursement);
}