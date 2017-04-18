/**
 * Changes the displayed invoice based on the -- on the assumption that all
 * invoice parameters have been loaded JSON Invoice List
 * @author rencela
 * @return
 */
function changeInvoiceOnDisplay(){
	var invoiceObj = null;
	try{
		var itemNo = getSelectedRowId("itemRow");
		var selCurr = $("selCurrency").options;
		var selectedCurrencyCode = parseInt($("selCurrency").options[$("selCurrency").selectedIndex].value);
		var selectedCurrencyRate = parseFloat($("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRate").replace(/,/g, ""));
		
		if(hasPerils()){
			var invoiceTaxList 	= null;
			var defaultTaxList	= null;
			
			for(var i = 0; i < objGIPIQuoteInvoiceList.length; i++){
				var invoice = objGIPIQuoteInvoiceList[i];
				if(selectedCurrencyCode == invoice.currencyCd && selectedCurrencyRate == invoice.currencyRt){
					invoiceObj = invoice;
				}
			}
		}else{
			showMessageBox("Item has no perils", imgMessage.ERROR);
		}
	}catch(e){
//		showErrorMessage("changeInvoiceOnDisplay", e);
	}
	return invoiceObj;
}