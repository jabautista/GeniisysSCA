/**
 * Pluck the invoiceTax object from the invoice object
 * 
 * @return
 */
function pluckTaxFromInvoice(){
	var invoice = pluckInvoiceFromList();
	var invoiceTaxes = null;
	var taxDesc = "";

	// get tax description
	$$("div[name='invoiceTaxRow']").each(function(taxRow){
		if(taxRow.hasClassName("selectedRow")){
			taxDesc = taxRow.down("label",0).innerHTML;
			$continue;
		}
	});
	
	var taxCd = "";
	// get invoice based on tax description
	if(invoice!=null){
		var taxOptions = $("selInvoiceTax").options;
		var currInvTax = null;
		for(var i=0; i<taxOptions.length; i++){
			if(taxOptions[i].innerHTML == taxDesc){
				taxCd = taxOptions[i].getAttribute("taxCd");
				invoiceTaxes = invoice.invoiceTaxes;
				for(var j=0; j<invoiceTaxes.length; j++){
					currInvTax = invoiceTaxes[j];
					if(currInvTax.taxCd == taxCd){
						return currInvTax;
					}
				}
				return null;
			}
		}
	}
	// selInvoiceTaxObj
	return null;
}