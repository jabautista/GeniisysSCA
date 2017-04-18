/*	Created by	: bry 12.08.2010
 * 	Description	: checks if there is a previously deleted object of same item prior to insertion of new object
 * 				  if so, marks the object as updated (recordStatus 1) otherwise, mark as new (recordStatus 0)
 */
function addNewItemObject(objArray, newObj){
	newObj.recordStatus = 0;
	for(var i = 0; i<objArray.length; i++){
		if ((objArray[i].itemNo == newObj.itemNo)
				&& (objArray[i].recordStatus == -1)){
			objArray.splice(i, 1);
			newObj.recordStatus = 1;
		}
	}
	objArray.push(newObj);
}