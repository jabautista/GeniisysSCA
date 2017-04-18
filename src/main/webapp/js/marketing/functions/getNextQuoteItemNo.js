/**
 * Gets the next item no(default item no) for Package Quotation
 * @param objArray - JSON Array that contains the list of items
 */

function getNextQuoteItemNo(objArray){
	var itemNo = 0;
	if(objArray.length > 0 && objArray != null){
		for(var i=0; i<objArray.length; i++){
			if(parseInt(nvl(objArray[i].itemNo, 0)) > parseInt(itemNo) && objArray[i].recordStatus != -1 ){
				itemNo = objArray[i].itemNo;
			}
		}
	}
	itemNo = parseInt(itemNo) + 1;
	
	return itemNo;
}