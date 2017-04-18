/**
 * Checks if allied peril of a basic peril is existing.
 * @param basicPerilCd - basic peril code
 * @return alliedPeril - returns a value if allied peril is existing.
 */

function checkAlliedPerilsIfExisting(basicPerilCd){
	var selectedItemRow = getSelectedRow("row");
	var alliedPeril = "";
	
	if(selectedItemRow != null){
		for(var i=0; i<objPackQuoteItemPerilList.length; i++){
			if(objPackQuoteItemPerilList[i].quoteId == objCurrPackQuote.quoteId &&
			   objPackQuoteItemPerilList[i].itemNo == selectedItemRow.getAttribute("itemNo") &&
			   objPackQuoteItemPerilList[i].recordStatus != -1 && 
			   objPackQuoteItemPerilList[i].basicPerilCd == basicPerilCd){
					alliedPeril = objPackQuoteItemPerilList[i].perilName;
					break;
			}
		}
	}
	return alliedPeril;
}