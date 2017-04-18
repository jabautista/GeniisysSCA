function getJSONObjectGrpItemsAH(objArray, tag){
	var newObjArray = new Array();
	
	if (objArray != null){
		for (var i = 0; i < objArray.length; i++){
			if (tag == 1){
				if (objArray[i].popBenefitsSw != null){
					newObjArray.push(objArray[i]);
				}
			} else if (tag == 2){
				if (objArray[i].retGrpItem != null){
					newObjArray.push(objArray[i]);
				}
			}
		}
	}
	
	return newObjArray;
}