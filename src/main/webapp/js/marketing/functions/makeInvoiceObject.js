/**
 * Make an Invoice Object
 * 
 * @return
 */
function makeInvoiceObject(){
	var newInvoice = new Object();
	newInvoice.quoteId = objGIPIQuote.quoteId;
	newInvoice.issCd = objGIPIQuote.issCd;
	newInvoice.quoteInvNo = invoiceSequence;	//newInvoice.quoteInvNo = invoiceSequence.quoteInvNo;
	invoiceSequence = invoiceSequence + 1;		//invoiceSequence.quoteInvNo = invoiceSequence.quoteInvNo + 1;
	newInvoice.currencyCd = $F("selCurrency");
	newInvoice.currencyRt = $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRate");
	newInvoice.premAmt = $F("txtTotalPremiumAmount").replace(/,/g, "");
	newInvoice.intmNo = $F("selIntermediary");
	newInvoice.taxAmt = 0;
	newInvoice.amountDue = 0;
	newInvoice.invoiceTaxes	= [];
	newInvoice.defaultInvoiceTaxes = null;
	newInvoice.recordStatus = 0;
	return newInvoice;
}