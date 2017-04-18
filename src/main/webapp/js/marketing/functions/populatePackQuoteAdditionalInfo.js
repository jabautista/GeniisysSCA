/**
 * Populate details to the additional information page
 * 
 */

function populatePackQuoteAdditionalInfo(){
	var lineCd = objCurrPackQuote.lineCd;
	var menuLineCd = objCurrPackQuote.menuLineCd;
	var itemNo = getSelectedRow("row").getAttribute("itemNo");
	var obj = null;
	
	for(var i=0; i<objPackQuoteItemList.length; i++ ){
		if(objPackQuoteItemList[i].quoteId == objCurrPackQuote.quoteId &&
		   objPackQuoteItemList[i].itemNo == itemNo && 
		   objPackQuoteItemList[i].recordStatus != -1){
			obj = objPackQuoteItemList[i];
		}
	}
	
	if(obj != null){
		if(lineCd == "FI" || menuLineCd == "FI"){
			supplyQuoteFIAdditional(obj.gipiQuoteItemFI);
		}else if(lineCd == "AC" || menuLineCd == "AC"){
			supplyQuoteAHAdditional(obj.gipiQuoteItemAC);
		}else if(lineCd == "AV" || menuLineCd == "AV"){
			supplyAVAdditional(obj.gipiQuoteItemAV);
		}else if(lineCd == "MN" || menuLineCd == "MN"){
			supplyQuoteMNAdditional(obj.gipiQuoteItemMN);
		}else if(lineCd == "EN" || menuLineCd == "EN"){
			supplyQuoteENAdditional(obj.gipiQuoteItemEN);
		}else if(lineCd == "CA" || menuLineCd == "CA"){
			supplyQuoteCAAdditional(obj.gipiQuoteItemCA);
		}else if(lineCd == "MH" || menuLineCd == "MH"){
			supplyQuoteMHAdditional(obj.gipiQuoteItemMH);
		}else if(lineCd == "MC" || menuLineCd == "MC"){
			supplyQuoteMCAdditional(obj.gipiQuoteItemMC);
			$("deductibleAmount").value = computeTotalDeductibleAmountForPackageQuotation();
			var dedAmt = unformatCurrencyValue($("deductibleAmount").value);
			var towAmt = unformatCurrencyValue($("towLimit").value);
			var repairLimitValue = parseFloat(nvl(dedAmt, 0)) + parseFloat(nvl(towAmt, 0));
			$("repairLimit").value = formatCurrency(repairLimitValue) ;
		}
	}
}