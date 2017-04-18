/**
* Populate quote invoice form with values.
* @param invoiceObj - JSON Object that contains the quote invoice information. Set invoiceObj
* 				      to null to reset quote invoice form. 
*/

function setQuoteInvoiceInfoForm(invoiceObj){
	$("hidQuoteInvNo").value = invoiceObj == null ? "" : invoiceObj.quoteInvNo;
	$("txtQuoteInvNo").value = invoiceObj == null ? "" : invoiceObj.issCd + " - " + (invoiceObj.quoteInvNo).toPaddedString(5);
	$("selIntermediary").value = invoiceObj == null ? "" : invoiceObj.intmNo;
	$("txtInvoicePremiumAmount").value = invoiceObj == null ? "" : formatCurrency(invoiceObj.premAmt);
	$("txtTotalTaxAmount").value = invoiceObj == null ? "" : formatCurrency(invoiceObj.taxAmt);
	$("txtAmountDue").value = invoiceObj == null ? "" : formatCurrency(parseFloat(nvl(invoiceObj.premAmt, 0)) + parseFloat(nvl(invoiceObj.taxAmt, 0)));
	$("txtCurrencyDescription").value = invoiceObj == null ? "" : unescapeHTML2(invoiceObj.currencyDesc);
}