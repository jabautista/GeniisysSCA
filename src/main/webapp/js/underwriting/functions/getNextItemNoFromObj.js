/*	Created by	: mark jm 01.19.2011
 * 	Description	: get the max item_no from item list + 1
 */
function getNextItemNoFromObj(){
	var itemNo = 1;	
	var maxItemNo = 0;
	
	maxItemNo = parseInt(objGIPIWItem.max(function(item) {
		return nvl(item.recordStatus, 0) != -1 && parseInt(item.itemNo);
	}));
	
	if(!(isNaN(maxItemNo))){
		if(maxItemNo == 999999999){
			var previous = 0;
			var objSorted = objGIPIWItem.sort(function(prev, curr) {
				return parseInt(prev.itemNo) - parseInt(curr.itemNo);
			});
			
			for(var i=0, length=objSorted.length; i < length; i++){
				if((objSorted[i].itemNo - previous) == 1){
					previous = objSorted[i].itemNo;
				}else{
					itemNo = previous + 1;
					break;
				}
			}
		}else{
			itemNo = maxItemNo + 1;
		}		
	}
	
	return itemNo;
}
