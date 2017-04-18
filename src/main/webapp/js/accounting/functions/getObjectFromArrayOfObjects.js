function getObjectFromArrayOfObjects(arrayObject, uniqueKeyList, searchValue) {
	var compareValue = "";
	var keyList = $w(uniqueKeyList);
	var returnObject = new Object();
	var indx = 0;
	for(var i=0; i<arrayObject.length; i++) {	
		returnObject = arrayObject[i];
		indx += 1;
		for (var k=0; k < keyList.length; k++) {
			compareValue += arrayObject[i][keyList[k]];
		}
		
		if (searchValue == compareValue) {
			returnObject.index = indx;
			return returnObject;
		}
		compareValue="";
	}
	return null;
}