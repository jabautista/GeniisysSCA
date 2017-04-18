/**
 * 
 */
function makeGIPIQuoteItemObject(){
	var itemObj = new Object();
	itemObj.quoteId = objGIPIQuote.quoteId;
	itemObj.itemNo = escapeHTML2($F("txtItemNo"));
	itemObj.itemTitle = escapeHTML2($F("txtItemTitle"));
	itemObj.itemDesc = escapeHTML2($F("txtItemDesc"));
	itemObj.itemDesc2 = escapeHTML2($F("txtItemDesc2"));
	itemObj.currencyCd = $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyCd");
	itemObj.currencyDesc = $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyDesc");
	itemObj.currencyRate = $F("txtCurrencyRate");//$("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRate");
    itemObj.coverageCd = $F("selCoverage").empty() ? null : $F("selCoverage");
    itemObj.coverageDesc = $("selCoverage").options[$("selCoverage").selectedIndex].getAttribute("coverageDesc");
    itemObj.recordStatus = 0;
    
    var lineCd = getLineCdMarketing(); 
    if (lineCd == "AC" || lineCd == "PA"){
    	itemObj.gipiQuoteItemAC = setQuoteAHAdditional(itemObj);
    }else if (lineCd == "FI"){
    	itemObj.gipiQuoteItemFI = makeFireAIObject();
    }else if (lineCd == "EN"){
    	itemObj.gipiQuoteItemEN = makeEngineeringAIObject();
    }else if(lineCd == "MH"){
    	itemObj.gipiQuoteItemMH = makeMarineHullAIObject();
    }else if(lineCd == "MN"){
    	itemObj.gipiQuoteItemMN = setQuoteMNAdditional(itemObj);
    }else if (lineCd == "AV"){
    	itemObj.gipiQuoteItemAV = setQuoteAVAdditional(itemObj);
    }else if (lineCd == "MC"){
    	itemObj.gipiQuoteItemMC = makeMotorCarAIObject();
    }else if(lineCd == "CA"){
    	itemObj.gipiQuoteItemCA = setQuoteCAAdditional(itemObj);
    }
    
    return itemObj;
}