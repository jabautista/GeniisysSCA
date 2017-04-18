/**
 * Computes the total tax amount of the current quote invoice.
 * @return totalTaxAmount - the computed total quote invoice tax.
 */

function computeTotalTaxAmountForPackageQuotation(){
	var selectedItemRow = getSelectedRow("row");
	var currQuoteInvoice = getCurrPackQuoteInvoice(selectedItemRow);
	var invoiceTaxes = currQuoteInvoice.invoiceTaxes;
	var totalTaxAmount = 0;
	
	for(var i=0; i<invoiceTaxes.length; i++){
		if(invoiceTaxes[i].recordStatus != -1){
			totalTaxAmount = parseFloat(totalTaxAmount) + parseFloat(nvl(invoiceTaxes[i].taxAmt, 0));
		}
	}
	
	return totalTaxAmount;
}