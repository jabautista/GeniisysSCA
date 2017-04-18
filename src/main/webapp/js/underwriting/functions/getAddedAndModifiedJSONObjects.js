function getAddedAndModifiedJSONObjects(objArray) {
	var tempObjArray = new Array();
	if(objArray != null){
		for (var i = 0; i<objArray.length; i++){
			if(parseInt(objArray[i].recordStatus) == 0 || parseInt(objArray[i].recordStatus) == 1){
				tempObjArray.push(objArray[i]);
			}		
		}
	}
	
	return tempObjArray;
}