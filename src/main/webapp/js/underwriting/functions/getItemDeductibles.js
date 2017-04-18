/*
 * Created by	: andrew robes
 * Date			: October 21, 2010
 * Description	: Retrieves the deductibles of the selected item
 * Parameters	: itemNo - number of selected item
 * 				  objArray - array of deductible objects
 */
function getItemDeductibles(itemNo, objArray) {
	var tempArray = new Array();
	for(var i=0; i<objArray.length; i++) {
		if (objArray[i].itemNo == itemNo && objArray[i].perilCd == 0 && nvl(objArray[i].recordStatus, 0) != -1){ //marco - added recordStatus condition
			tempArray.push(JSON.parse(JSON.stringify(objArray[i])));
		}
	}
	return tempArray;
}