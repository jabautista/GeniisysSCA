/*	Created by	: mark jm 10.18.2010
 * 	Description	: returns the next item no (max + 1)
 * 	Parameters	: tableName - div id of the table
 * 				: rowName - div name which acts as rows
 * 				: elementType - type of element where the item no is located
 * 				: index - index of the element type
 */
function getNextItemNo(tableName, rowName, elementType, index){
	var itemNos 	= "";
	var nextItemNo	= 1;
	
	if(elementType == "label"){
		$$("div#" + tableName + " div[name='" + rowName+ "']").each(function(row){
			itemNos = itemNos + parseInt(row.down(elementType, index).innerHTML) + " ";
		});
	}else{
		$$("div#" + tableName + " div[name='" + rowName+ "']").each(function(row){
			itemNos = itemNos + parseInt(row.down(elementType, index).value) + " ";
		});
	}	
	
	//nextItemNo = parseInt(nextItemNo) + parseInt(sortNumbers(itemNos.trim()).last());
	var numbers = itemNos.split(" ").map(Number); // andrew - 08192015 - SR 4594
	nextItemNo = parseInt(nextItemNo) + parseInt(numbers.max()); // andrew - 08192015 - SR 4594
	
	return nextItemNo;
}