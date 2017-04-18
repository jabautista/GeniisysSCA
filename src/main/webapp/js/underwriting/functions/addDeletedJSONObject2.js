/* Created by: angelo 12.17.2010
 * Description: same as addDeletedJSONObject; added objProperty to prevent deleting a different object with the same item number
 */
function addDeletedJSONObject2(objArray, deletedObj, objProperty){
	var removed = false;
	for (var i=0; i<objArray.length; i++) {
		if(objArray[i].recordStatus != 0 && objArray[i].itemNo == deletedObj.itemNo && objArray[objProperty] == deletedObj[objProperty]){
			objArray.splice(i, 1);
			removed = true;
		}else if(objArray[i].recordStatus == 0 && objArray[i].itemNo == deletedObj.itemNo){
			objArray.splice(i, 1); 
		}
	}
	if(removed){
		deletedObj.recordStatus = -1;
		objArray.push(deletedObj);
	}
}