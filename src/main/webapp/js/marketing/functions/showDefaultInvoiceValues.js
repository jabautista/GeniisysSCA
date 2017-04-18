/**
 * Show the Default Values for invoice
 * @return
 */
function showDefaultInvoiceValues(){ // doThis
	try{
		var newInvoice = makeInvoiceObject();
		//var premAmt	= parseFloat($F("txtTotalPremiumAmount").replace(/,/g, ""));
		newInvoice.intmNo = 0;
		$("selIntermediary").value = 0; // set to default 0;
		$("txtInvoicePremiumAmount").value = formatCurrency(newInvoice.premAmt);
		$("txtTotalTaxAmount").value = formatCurrency(0);
		$("txtAmountDue").value = formatCurrency(newInvoice.premAmt);
		if($("txtCurrencyDescription")!=null){
			$("txtCurrencyDescription").value = $("selCurrency").options[$("selCurrency").selectedIndex].text;
		}
		if(objGIPIQuoteInvoiceList==null){
			objGIPIQuoteInvoiceList = new Array();
		}
		objGIPIQuoteInvoiceList.push(newInvoice);
		showDefaultInvoiceTaxes(newInvoice);
		// show defaultTaxes
		return newInvoice;
	}catch(e){
		//showMessageBox("showDefaultInvoiceValues: " + e, imgMessage.ERROR);
		return null;
	}
}