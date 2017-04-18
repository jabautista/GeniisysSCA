function getAddedJSONObjectList(objArray){
	var tempObjArray = new Array();
	for(var i = 0; i<objArray.length; i++){
		if(objArray[i].recordStatus == 0){
			tempObjArray.push(objArray[i]);
		}
	}
	return tempObjArray;
}