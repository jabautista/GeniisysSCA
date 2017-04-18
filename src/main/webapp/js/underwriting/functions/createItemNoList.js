/*	Created by	: mark jm 12.15.201
 * 	Description	: create a list of itemNo
 */
function createItemNoList(objArray){	
	for(var index=0, length=objArray.length; index < length; index++){
		objItemNoList.push({"itemNo" : objArray[index].itemNo});
	}
}