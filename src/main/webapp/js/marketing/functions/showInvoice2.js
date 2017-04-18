function showInvoice2(){
	$("invoiceAccordionLbl").innerHTML	= "Hide";
	$("invoiceAccordionLbl").value		= "Hide"; // as a precaution
	$("invoiceInformationMotherDiv").show();
	
	var anInvoice = pluckInvoiceFromList();
	if(anInvoice==null){
		anInvoice = showDefaultInvoiceValues();
	}

	var premiumAmountOfCurrency = computeInvoicePremiumAmountPerCurrency(anInvoice.currencyCd, anInvoice.currencyRt);
	anInvoice.premAmt = premiumAmountOfCurrency;
	displayInvoice(anInvoice);
}