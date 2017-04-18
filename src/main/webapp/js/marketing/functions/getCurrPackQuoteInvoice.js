/**
 * Gets the quote invoice for the selected item considering 
 * its quoteId and the currencyCd
 * @param itemRow - the selected item row
 * @return quoteInvoice - the quote invoice object
 */

function getCurrPackQuoteInvoice(itemRow){
	var quoteInvoice = null;
	
	for(var i=0; i<objPackQuoteInvoiceList.length; i++){
		if(objPackQuoteInvoiceList[i].quoteId == objCurrPackQuote.quoteId && 
		   objPackQuoteInvoiceList[i].currencyCd == itemRow.getAttribute("currencyCd")
		   && objPackQuoteInvoiceList[i].recordStatus != -1){
				quoteInvoice = objPackQuoteInvoiceList[i];
				break;
		}
	}
	return quoteInvoice;
}