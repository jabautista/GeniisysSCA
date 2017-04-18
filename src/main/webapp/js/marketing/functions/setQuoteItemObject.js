/**
 * Creates a new object for quote item
 * @param quoteId - the quote id
 * @return quoteItem - quote item object
 */

function setQuoteItemObject(quoteId, isAdditionalInfoIncluded){
	var quoteItem = new Object();
	
	try{
		var lineCd = objCurrPackQuote.lineCd;
		var menuLineCd = objCurrPackQuote.menuLineCd;
		
		quoteItem.quoteId 		= quoteId;
		quoteItem.lineCd		= lineCd;
		quoteItem.menuLineCd	= menuLineCd;
		quoteItem.itemNo 		= $("txtItemNo").value;
		quoteItem.itemTitle 	= escapeHTML2($("txtItemTitle").value);
		quoteItem.itemDesc 		= escapeHTML2($("txtItemDesc").value);
		quoteItem.itemDesc2 	= escapeHTML2($("txtItemDesc2").value);
		quoteItem.currencyCd 	= $("selCurrency").value;
		quoteItem.currencyDesc 	= escapeHTML2($("selCurrency").options[$("selCurrency").selectedIndex].text);
		quoteItem.currencyRate 	= $("txtCurrencyRate").value == "" ? null : parseFloat($("txtCurrencyRate").value);
		quoteItem.coverageCd 	= $("selCoverage").value;
		quoteItem.coverageDesc 	= escapeHTML2($("selCoverage").options[$("selCoverage").selectedIndex].text);
	
		if(isAdditionalInfoIncluded){
		    if (lineCd == "AC" || menuLineCd == "AC"){ 
		    	quoteItem.gipiQuoteItemAC = setQuoteAHAdditional(quoteItem);
		    }else if (lineCd == "FI" || menuLineCd == "FI"){
		    	quoteItem.gipiQuoteItemFI = makeFireAIObject();
		    }else if(lineCd == "MH" || menuLineCd == "MH"){
		    	quoteItem.gipiQuoteItemMH = makeMarineHullAIObject();
		    }else if(lineCd == "MN" || menuLineCd == "MN"){
		    	quoteItem.gipiQuoteItemMN = setQuoteMNAdditional(quoteItem);
		    }else if (lineCd == "AV" || menuLineCd == "AV") {
		    	quoteItem.gipiQuoteItemAV = setQuoteAVAdditional(quoteItem);
		    }else if (lineCd == "MC" || menuLineCd == "MC"){
		    	quoteItem.gipiQuoteItemMC = makeMotorCarAIObject();
		    }else if(lineCd == "CA" || menuLineCd == "CA"){
		    	quoteItem.gipiQuoteItemCA = setQuoteCAAdditional(quoteItem);
		    }else if (lineCd == "EN" || menuLineCd == "EN"){
		    	var objEN = makeEngineeringAIObject();
		    	quoteItem.gipiQuoteItemEN = objEN;
		    	for(var i=0; i<objPackQuoteItemList.length; i++){
		    		if(objPackQuoteItemList[i].quoteId == quoteId){
		    			objPackQuoteItemList[i].gipiQuoteItemEN = objEN;
		    		}
		    	}
		    }
		}else{
			if (lineCd == "EN" || menuLineCd == "EN"){
				for(var i=0; i<objPackQuoteItemList.length; i++){
		    		if(objPackQuoteItemList[i].quoteId == quoteId){
		    			quoteItem.gipiQuoteItemEN = objPackQuoteItemList[i].gipiQuoteItemEN;
		    			break;
		    		}
		    	}
			}else if (lineCd == "MC" || menuLineCd == "MC"){ //added by steven 11/8/2012 - para makita ko kung may laman ung Car Company.
		    	quoteItem.gipiQuoteItemMC = makeMotorCarAIObject();
		    }
		}
	}catch(e){
		showErrorMessage("setQuoteItemObject", e);
		return null;
	}
	return quoteItem;
}