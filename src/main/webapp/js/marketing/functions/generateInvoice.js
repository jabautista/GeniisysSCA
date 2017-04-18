/**
 * Generates invoice on background when a new peril is created
 * - this function does not actually display the invoiceInformation subpage.
 * - removes the need to click "Show" in invoice subpage to generate the necessary invoice 
 * @return
 */
function generateInvoice(){
	if($("selInvoiceTax") == null){//if(objGIPIQuoteInvoiceList==null ){
		//showNotice("Loading Invoice Information...");
		if(loadInvoiceInformationAccordion()){	// empty statement - DO NOT ERASE
		}
		if(objGIPIQuoteInvoiceList==null){
			objGIPIQuoteInvoiceList = new Array();
		}
		var invoiceForThisItem = pluckInvoiceFromList();
		if(invoiceForThisItem == null){
			invoiceToBeDisplayed = showDefaultInvoiceValues(); // also pushes the invoice to array
		}
		/*else{
			invoiceToBeDisplayed = invoiceForThisItem;
		}*/
	}
	hideInvoice();
}