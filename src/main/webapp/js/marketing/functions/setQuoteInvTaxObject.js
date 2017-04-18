/**
 * Creates a new object for quote invoice tax
 * @return objInvTax - quote invoice tax object
 */

function setQuoteInvTaxObject(){
	try{
		var objInvTax = new Object();
		objInvTax.lineCd = objCurrPackQuote.lineCd;
		objInvTax.issCd = objCurrPackQuote.issCd;
		objInvTax.quoteInvNo = $F("hidQuoteInvNo");
		objInvTax.taxCd = $("txtTaxCharges").getAttribute("taxCd");
		objInvTax.taxId = $("txtTaxCharges").getAttribute("taxId");
		objInvTax.rate = $("txtTaxCharges").getAttribute("rate");
		objInvTax.taxAmt = unformatCurrencyValue($("txtTaxValue").value);
		objInvTax.primarySw = $("txtTaxCharges").getAttribute("primarySw");
		objInvTax.taxDescription = $("txtTaxCharges").value;
		return objInvTax;
	}catch(e){
		showErrorMessage("setQuoteInvTaxObject", e);
		return null;
	}
}