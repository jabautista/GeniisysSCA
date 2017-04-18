function getInvoiceFromList(currencyCd, currencyRate){
	var targetInvoice = null;
	for(var i=0; i<objGIPIQuoteInvoiceList.length; i++){
		var invoice = objGIPIQuoteInvoiceList[i];
		//if(invoice.currencyCd == currencyCd && invoice.currencyRate == currencyRate){ // andrew - 10.21.2011
		if(invoice.currencyCd == currencyCd && invoice.currencyRt == currencyRate){
			targetInvoice = invoice;
			i = objGIPIQuoteInvoiceList.length;
		}
	}
	return targetInvoice;
}