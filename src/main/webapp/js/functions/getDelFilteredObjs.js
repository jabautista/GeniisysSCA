/*	Created by	: mark jm 11.19.2010
 * 	Description	: returns array of deleted object (filtered)
 * 				: to exclude unnecessary objects in deleting
 * 	Parameters	: objArray - data source/array of objects
 */
function getDelFilteredObjs(objArray){
	var tempObjArray = new Array();
	
	if(objArray != null){
		for(var i=0; i < objArray.length; i++){
			if(objArray[i].recordStatus == -1 && nvl(objArray[i].origRecord, true)){
				tempObjArray.push(objArray[i]);
			}
		}
	}
	
	return tempObjArray;
}