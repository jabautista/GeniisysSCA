/**
 * Creates a new object for quote deductible
 * @return objDeductible - quote deductible object
 */

function setQuoteDeductibleObject(){
	try{
		var objDeductible = new Object();
		objDeductible.quoteId 	= objCurrPackQuote.quoteId;
		objDeductible.itemNo  	= $("txtItemDisplay").getAttribute("itemNo");
		objDeductible.perilCd 	= escapeHTML2($F("selDeductibleQuotePerils"));
		objDeductible.perilName = escapeHTML2($("txtPerilDisplay").value);
		objDeductible.dedDeductibleCd = escapeHTML2($("txtDeductibleTitle").getAttribute("deductibleCd"));
		objDeductible.deductibleTitle = escapeHTML2($("txtDeductibleTitle").value);
		objDeductible.deductibleText = escapeHTML2($("txtDeductibleText").value);
		objDeductible.deductibleRate = $("txtDeductibleRate").value == "" ? null : parseFloat($("txtDeductibleRate").value);
		objDeductible.deductibleAmt = unformatCurrencyValue($("txtDeductibleAmt").value);
		objDeductible.deductibleType = escapeHTML2($("txtDeductibleTitle").getAttribute("deductibleType"));
		return objDeductible;
	}catch(e){
		showErrorMessage("setQuoteDeductibleObject", e);
		return null;
	}
}