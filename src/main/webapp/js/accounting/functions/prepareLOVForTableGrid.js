function prepareLOVForTableGrid(lovObj, lovObjValue, lovObjText) {
	var listing = new Array();
	listing.push({
		"value" : "",
		"text" : ""
	});

	var listObject1 = new Object();
	listObject1.value = "";
	listObject1.text = "";
	listing.push(listObject1); // added null value

	for ( var i = 0; i < lovObj.length; i++) {
		var listObject = new Object();
		var tempObj = lovObj[i];
		listObject.value = tempObj[lovObjValue];
		listObject.text = tempObj[lovObjText];
		listing.push(listObject);
	}

	return listing;
}