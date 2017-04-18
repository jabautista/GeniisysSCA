/**
 * Creates a new peril object(GIPIQuoteItemPerilSummary) - this does not add the
 * object to any list
 * 
 * @author rencela
 * @return new peril object
 */
function makeGIPIQuoteItemPerilObject(){
	try{
		var objNewPeril = new Object();
		objNewPeril.recordStatus = 0;
		objNewPeril.quoteId = objGIPIQuote.quoteId;
		objNewPeril.itemNo = $F("txtItemNo");
		objNewPeril.itemTitle = $F("txtItemTitle");
		objNewPeril.itemDesc = $F("txtItemDesc");
		objNewPeril.currencyCd = $F("selCurrency");
		objNewPeril.currencyDesc = $("selCurrency").options[$("selCurrency").selectedIndex].text;
		objNewPeril.currencyRate = $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRate");// $("currFloat").options[$("currency").selectedIndex].text;
		objNewPeril.coverageCd = $F("selCoverage");
		objNewPeril.coverageDesc = $("selCoverage").options[$("selCoverage").selectedIndex].text;
		objNewPeril.perilCd = $F("selPerilName");
		objNewPeril.perilName = $("selPerilName").options[$("selPerilName").selectedIndex].getAttribute("perilName");
		objNewPeril.perilType = $("selPerilName").options[$("selPerilName").selectedIndex].getAttribute("perilType");
		objNewPeril.wcSw = $("selPerilName").options[$("selPerilName").selectedIndex].getAttribute("wcSw");
		objNewPeril.basicPerilCd = $("selPerilName").options[$("selPerilName").selectedIndex].getAttribute("basicPeril");
		objNewPeril.perilRate = parseFloat($F("txtPerilRate").replace(/\$|\,/g,''));
		objNewPeril.tsiAmount = parseFloat($F("txtTsiAmount").replace(/\$|\,/g,''));
		objNewPeril.premiumAmount = $F("txtPremiumAmount").replace(/\$|\,/g,'');
		objNewPeril.annPremAmt = $F("txtPremiumAmount").replace(/\$|\,/g,'');
		objNewPeril.compRem = $F("txtRemarks");
		objNewPeril.lineCd = objGIPIQuote.lineCd;
		return objNewPeril;
	}catch(e){
		showMessageBox("Error in function makeGIPIQuoteItemPerilObject() " + e, imgMessage.ERROR);
		return null;
	}
}