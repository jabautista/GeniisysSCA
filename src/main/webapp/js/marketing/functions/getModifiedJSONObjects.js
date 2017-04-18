function getModifiedJSONObjects(objArray){
	var tempObjArray = new Array();
	for(var i = 0; i<objArray.length; i++){
		if(objArray[i].recordStatus == 1){
			tempObjArray.push(objArray[i]);
		}
	}
	return tempObjArray;
}