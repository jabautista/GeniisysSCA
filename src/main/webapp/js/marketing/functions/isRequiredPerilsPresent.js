/**
 * Check if the taxCode's requiredPerils have been added
 * @author rencela
 * @return
 */
function isRequiredPerilsPresent(taxCode){
	var currentTax = "";
	var currentPeril = "";
	var invoiceObj = pluckInvoiceFromList();
	
	if(invoiceObj!=null){
		var defaultTaxes = invoiceObj.defaultInvoiceTaxes;
		var invTax = null;
		for(var i = 0; i < defaultTaxes.length; i++){
			invTax = defaultTaxes[i];
			if(invTax.taxCd == taxCode){
				return true;
			}
		}
	}
	return false;
}