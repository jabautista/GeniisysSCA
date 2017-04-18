/**
 * Check if the :taxCode in the select-element has already been added
 * @param taxCode
 * @param itemNo
 * @author rencela
 * @return
 */
function isInvoiceTaxCodeAlreadyAdded(taxCode){
	var invoice = pluckInvoiceFromList(); // no need
	var defaultTaxes = null;
	var invTaxes = null;
	
	if(invoice!=null){
		defaultTaxes 	= invoice.defaultInvoiceTaxes;
		invTaxes		= invoice.invoiceTaxes;
		var invTax		= null;
		for(var i=0; i<invTaxes.length; i++){
			if(invTaxes[i].taxCd == taxCode){
				return true;
			}
		}
	}
	return false;
}