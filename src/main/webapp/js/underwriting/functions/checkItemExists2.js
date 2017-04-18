//bjga 11.23.2010
//This function returns true if item number exists in objItems, otherwise false
//Parameter 	:	itemNo - itemNo to search
function checkItemExists2(itemNo){
	var itemExists = false;
	if (objGIPIWItem != null){
		for (var i = 0; i<objGIPIWItem.length; i++){
			if (objGIPIWItem[i].itemNo == itemNo
					&& objGIPIWItem[i].recordStatus != -1){
				itemExists = true;
				break;
			}
		}
	}
	
	//temporarily added while itemListing is not yet JSONized
	/*$$("div#parItemTableContainer div[name='rowItem'").each(function(item){
		if (item.getAttribute("itemNo") == itemNo){
			itemExists = true;
		}
	});*/
	
	return itemExists;
}