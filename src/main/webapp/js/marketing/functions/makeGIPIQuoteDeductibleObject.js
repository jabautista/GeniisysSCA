/**
 * Make GIPIQuoteDeductible json object
 * #makeObject
 * @return
 */
function makeGIPIQuoteDeductibleObject(){
	var newDeductible = null;
	try{
		newDeductible = new Object();
		newDeductible.quoteId = objGIPIQuote.quoteId;
		newDeductible.itemNo = getSelectedRowId("itemRow");
		newDeductible.perilCd = $("selDeductibleQuotePerils").options[$("selDeductibleQuotePerils").selectedIndex].getAttribute("perilCd");
		newDeductible.perilName = escapeHTML2($("selDeductibleQuotePerils").options[$("selDeductibleQuotePerils").selectedIndex].getAttribute("perilName"));
		newDeductible.dedDeductibleCd = $F("selDeductibleDesc");
		newDeductible.deductibleTitle = escapeHTML2($("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].text);
		newDeductible.deductibleText = escapeHTML2($F("txtDeductibleText"));
		newDeductible.deductibleAmt = $F("txtDeductibleAmt") == "--" ? 0 : $F("txtDeductibleAmt").replace(/,/g, "");
		newDeductible.deductibleRate = isNaN($F("txtDeductibleRate"))? 0 : $F("txtDeductibleRate").replace(/,/g, "");
		newDeductible.deductibleType = $("selDeductibleDesc").options[$("selDeductibleDesc").selectedIndex].getAttribute("deductibleType");
	}catch(e){
		showErrorMessage("makeGIPIQuoteDeductibleObject", e);
	}
	return newDeductible;
}