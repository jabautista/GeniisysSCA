/**
 * Clear recordStatus of all object arrays used in Package Quotation
 * Information. Necessary when package quotation information is already
 * been saved.
 * 
 */

function clearPackQuotationObjects(){
	clearObjectRecordStatus(objPackQuoteItemList);
	clearObjectRecordStatus(objPackQuoteItemPerilList);
	clearObjectRecordStatus(objPackQuoteDeductiblesList);
	clearObjectRecordStatus(objPackQuoteMortgageeList);
	clearObjectRecordStatus(objPackQuoteInvoiceList);
	
	for(var i=0; i<objPackQuoteInvoiceList.length; i++){
		clearObjectRecordStatus(objPackQuoteInvoiceList[i].invoiceTaxes);
	}
}