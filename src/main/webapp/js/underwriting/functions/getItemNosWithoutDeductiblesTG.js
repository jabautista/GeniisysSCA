/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.17.2011	mark jm			Retrieves the number of items without deductibles (table grid version)
 * 								Parameters : objArray - array of deductible objects
 */
function getItemNosWithoutDeductiblesTG(objArray) {
	try {
		var tempArray = new Array();
		var itemNos = new Array();		
		
		for(var i=0, length=objGIPIWItem.length; i < length; i++){
			itemNos.push(parseInt(objGIPIWItem[i].itemNo));
		}
		
		var exist = null;			
		itemNos.any(function(no) {
			exist = false;
			for(var i=0; i<objArray.length; i++) {
				if (objArray[i].itemNo == no && objArray[i].perilCd == 0) {
					exist = true;
				}
			}
			
			if (!exist){
				tempArray.push(no);
			}				
		});	
		
		return tempArray;
	} catch(e){
		showErrorMessage("getItemNosWithoutDeductiblesTG", e);
	}
}