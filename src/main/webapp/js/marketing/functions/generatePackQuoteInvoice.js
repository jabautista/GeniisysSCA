/**
 * Generates a quote invoice object that holds values
 * to be used as parameters for creating new quote 
 * invoice upon saving. 
 * 
 */

function generatePackQuoteInvoice(){
	var itemRow = getSelectedRow("row");
	var newInv = new Object();
	newInv.quoteId = objCurrPackQuote.quoteId;
	newInv.issCd = objCurrPackQuote.issCd;
	newInv.quoteInvNo = 0;
	newInv.currencyCd = itemRow.getAttribute("currencyCd");
	newInv.currencyDesc = escapeHTML2($("selCurrency").options[$("selCurrency").selectedIndex].text);
	newInv.currencyRt = itemRow.getAttribute("currencyRt");
	newInv.premAmt = 0.00;
	newInv.taxAmt = 0.00;
	newInv.intmNo = 0;
	newInv.invoiceTaxes = [];
	newInv.recordStatus = 0;
	objPackQuoteInvoiceList.push(newInv);
	quotePerilChangeTag = 1;
}