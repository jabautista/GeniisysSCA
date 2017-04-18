/**
 * 
 */
function loadInvoiceSubpage(){
	if(checkPendingRecordChanges()){ // Patrick - added condition for validation - 02.14.2012
		new Ajax.Updater("invoiceInformationMotherDiv", contextPath + "/GIPIQuotationInvoiceController?action=showQuoteInvoicePage",{
			asynchronous:	true,
			evalScripts:	true,
			method:			"GET",
			parameters:{
				quoteId:	objGIPIQuote.quoteId
			},
			onComplete: function(response){
				changeInvoiceOnDisplay();
				enableQuotationMainButtons();
				showAccordionLabelsOnQuotationMain();
			}
		});
	}
}