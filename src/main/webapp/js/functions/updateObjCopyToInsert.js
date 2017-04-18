/*	Created by	: mark jm 10.18.2010
 * 	Description	: update the record status of copied records to insert
 * 	Parameter	: objArray - array of objects containing the records
 * 				: itemNo - for comparison
 */
function updateObjCopyToInsert(objArray, itemNo){
	if(objArray != null){
		for(var i=0, length=objArray.length; i < length; i++){
			if(objArray[i].itemNo == itemNo && objArray[i].recordStatus == 2){
				objArray[i].recordStatus = 0;
			}
		}
	}	
}