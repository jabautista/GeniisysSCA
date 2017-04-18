/**
 * Picks up the invoice of the selected QuoteItem
 * 
 * @return
 */
function pluckInvoiceFromList(){
	var invoice = null;
	var selectedCurrencyCd		= $F("selCurrency").replace(/,/g, "");
	var selectedCurrencyRate 	= $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRate").replace(/,/g, "");

	for(var i=0; i<objGIPIQuoteInvoiceList.length; i++){
		invoice = objGIPIQuoteInvoiceList[i];
		if(parseInt(objGIPIQuoteInvoiceList[i].currencyCd) == parseInt(selectedCurrencyCd) &&
				parseFloat(objGIPIQuoteInvoiceList[i].currencyRt) == parseFloat(selectedCurrencyRate)){
			invoice = objGIPIQuoteInvoiceList[i];
		}
	}
	return invoice;
}