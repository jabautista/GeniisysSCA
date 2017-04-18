/*	Created by	: mark jm 10.19.2010
 * 	Description	: determines if records exist in grouped item listing and loads it to screen
 * 	Parameter	: rowName - name of row used in table record listing
 * 				: row - div that holds the record
 * 				: id - row id
 */
function loadSelectedGroupedItem(rowName, row){
	/*
	for(var i=0, length=objEndtGroupedItems.length; i < length; i++){
		//var groupedItemNo = id.substr(id.indexOf("_") + 1, id.length - id.indexOf("_"));
		if(objEndtGroupedItems[i].itemNo == row.getAttribute("itemNo") && 
				objEndtGroupedItems[i].groupedItemNo == row.getAttribute("groupedItemNo")){						
			setValues(rowName, objEndtGroupedItems[i]);			
			break;							
		}
	}
	*/
	try{
		if(row.hasClassName("selectedRow")){
			var objArr = objGIPIWGroupedItems.filter(function(obj){	return nvl(obj.recordStatus,0) != -1 && obj.itemNo == row.getAttribute("item") && obj.groupedItemNo == row.getAttribute("groupedItemNo");	});
			for(var i=0, length=objArr.length; i < length; i++){
				setGroupedItemsForm(objArr[i]);
				break;
			}
		}else{
			setGroupedItemsForm(null);
		}
	}catch(e){
		showErrorMessage("loadSelectedGroupedItem", e);
	}	
}