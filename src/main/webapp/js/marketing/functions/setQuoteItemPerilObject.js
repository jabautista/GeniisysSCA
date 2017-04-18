/**
 * Creates a new object for quote item peril
 * @return objPeril - quote peril object
 */

function setQuoteItemPerilObject(){
	try{
		var objPeril = new Object();
		objPeril.quoteId = objCurrPackQuote.quoteId;
		objPeril.itemNo = $F("txtItemNo");
		objPeril.itemTitle = escapeHTML2($F("txtItemTitle"));
		objPeril.itemDesc = escapeHTML2($F("txtItemDesc"));
		objPeril.currencyCd = $F("selCurrency");
		objPeril.currencyDesc = escapeHTML2($("selCurrency").options[$("selCurrency").selectedIndex].text);
		objPeril.currencyRate = parseFloat($("txtCurrencyRate").value);
		objPeril.coverageCd = $F("selCoverage");
		objPeril.coverageDesc = escapeHTML2($("selCoverage").options[$("selCoverage").selectedIndex].text);
		
		objPeril.perilCd = $("txtPerilName").getAttribute("perilCd");
		objPeril.perilName = escapeHTML2($("txtPerilName").value); 
		objPeril.perilType = $("txtPerilName").getAttribute("perilType");
		objPeril.wcSw = "N";
		objPeril.basicPerilCd = $("txtPerilName").getAttribute("basicPerilCd"); 
		objPeril.perilRate = $F("txtPerilRate") == "" ? null : parseFloat($F("txtPerilRate"));
		objPeril.tsiAmount = unformatCurrencyValue($F("txtTsiAmount"));
		objPeril.premiumAmount = unformatCurrencyValue($F("txtPremiumAmount"));
		objPeril.annPremAmt = unformatCurrencyValue($F("txtPremiumAmount"));
		objPeril.compRem = escapeHTML2($F("txtRemarks"));
		objPeril.lineCd = escapeHTML2(objCurrPackQuote.lineCd);
		return objPeril;
	}catch(e){
		showErrorMessage("setQuoteItemPerilObject", e);
		return null;
	}
}