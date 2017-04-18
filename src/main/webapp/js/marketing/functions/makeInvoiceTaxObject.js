/**
 * Make Invoice Tax Object
 * @return
 */
function makeInvoiceTaxObject(selInvoiceTaxIndex){
	var newTax = new Object();	
	selInvoiceTaxIndex = parseInt(selInvoiceTaxIndex);
	
	if(selInvoiceTaxIndex == -1){
		return null;
	}else{
		newTax.lineCd = objGIPIQuote.lineCd; 
		newTax.issCd = objGIPIQuote.issCd;
		newTax.quoteInvNo = 0;
		newTax.taxCd = $("selInvoiceTax").options[selInvoiceTaxIndex].value;
		newTax.taxId = $F("selTaxId");
		newTax.taxAmt = $F("txtTaxValue").replace(/,/g, ""); 
		newTax.rate	= $("selInvoiceTax").options[selInvoiceTaxIndex].getAttribute("rate");
		newTax.fixedTaxAllocation = null;
		newTax.itemGrp = null;
		newTax.taxAllocation = null;
		newTax.amountDue = 0; 
		newTax.recordStatus = 0;
	}
	return newTax;
}