/**
 * Sets the invoice Object contents to the Invoice Form - displays the
 * invoiceTaxes for invoice - does NOT display the DEFAULT invoice taxes
 * @return
 */
function displayInvoice(invoice){
	if(invoice!=null){
		$("txtQuoteInvNo").value = objGIPIQuote.issCd + " - " + parseInt(invoice.quoteInvNo).toPaddedString(5);
		$("txtCurrencyDescription").value = $("selCurrency").options[$("selCurrency").selectedIndex].text;
		$("txtInvoicePremiumAmount").value = formatCurrency(invoice.premAmt);
		$("txtTotalTaxAmount").value = formatCurrency(invoice.taxAmt);
		$("txtAmountDue").value = formatCurrency(invoice.premAmt);// temporary
																	// formatCurrency(invoice.amountDue);
		setSelectedIntermediary(invoice.intmNo);
		var invoiceTaxList = invoice.invoiceTaxes;
		var defaultTaxList = invoice.defaultInvoiceTaxes;
		if(invoiceTaxList != null){
			// display existing invoicetaxes
			for(var i=0; i<invoiceTaxList.length; i++){
				createInvoiceTaxRow(invoiceTaxList[i]);
			}
		}
	}
	showInvoice();
	hideSelectedTaxDescriptions();
	updateTaxAmountAndAmountDue();
}