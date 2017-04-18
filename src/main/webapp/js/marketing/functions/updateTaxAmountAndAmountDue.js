function updateTaxAmountAndAmountDue(){
	try{
		var invoice = pluckInvoiceFromList();
		var invoiceTaxes = invoice.invoiceTaxes;
		var taxAmt = 0;
		
		$$("div[name='invoiceTaxRow']").each(function(taxRow){
			taxAmt = taxAmt + parseFloat(taxRow.down("label", 1).innerHTML.replace(/,/g, ""));
		});
		
		$("txtTotalTaxAmount").value = formatCurrency(taxAmt);
		invoice.taxAmt = taxAmt;
		
		$("txtAmountDue").value = formatCurrency(parseFloat($F("txtTotalTaxAmount").replace(/,/g, ""))
				+ parseFloat($F("txtInvoicePremiumAmount").replace(/,/g, "")));
		
	}catch(e){
		showErrorMessage("updateTaxAmountAndAmountDue", e);
	}
}