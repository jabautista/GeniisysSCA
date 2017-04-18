/**
 * Retrive item object having :itemNo from List - ignore records having recordStatus = -1
 * @return item
 */
function getGIPIQuoteItemFromList(itemNo){
	var item = null;
	for(var i=0; i<objGIPIQuoteItemList.length; i++){
		var temp = objGIPIQuoteItemList[i];
		if(temp.itemNo == itemNo && temp.recordStatus != -1){
			item = objGIPIQuoteItemList[i];
		}
	}
	return item;
}