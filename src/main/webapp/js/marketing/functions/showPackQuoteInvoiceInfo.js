/**
 * Shows invoice record for the selected item and 
 * under the Package Quotation.
 */

function showPackQuoteInvoiceInfo(){
	var selectedItemRow = getSelectedRow("row");
	
	if(selectedItemRow != null){
		var currQuoteInvoice = getCurrPackQuoteInvoice(selectedItemRow); 
		
		if(currQuoteInvoice != null){
			setQuoteInvoiceInfoForm(currQuoteInvoice);
			showQuoteInvoiceTaxListing(currQuoteInvoice.invoiceTaxes);
		}
		
	}else{
		setQuoteInvoiceInfoForm(null);
		showQuoteInvoiceTaxListing(null);
	}
}