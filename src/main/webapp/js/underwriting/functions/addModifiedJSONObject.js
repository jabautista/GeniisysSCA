function addModifiedJSONObject(objArray, editedObj) {
	editedObj.recordStatus = editedObj.recordStatus == 0 ? 0 :1;//BJGA 12.16.2010 for editing newly-inserted object in array
	for (var i=0; i<objArray.length; i++) {
		//if(objArray[i].recordStatus == 0 && objArray[i].itemNo == editedObj.itemNo){		
		if(parseInt(objArray[i].itemNo) == parseInt(editedObj.itemNo)){ // mark jm 10.10.2011 added parseInt for comparison
			objArray.splice(i, 1);
			objArray.push(editedObj);
		}
	}	
}