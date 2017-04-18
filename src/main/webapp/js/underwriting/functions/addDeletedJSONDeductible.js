function addDeletedJSONDeductible(deletedObj) {
	try{
		deletedObj.recordStatus = -1;		
		var existIndex = 0;
		for (var i=0; i<objDeductibles.length; i++) {
			if(objDeductibles[i].itemNo == deletedObj.itemNo && objDeductibles[i].perilCd == deletedObj.perilCd && objDeductibles[i].dedDeductibleCd == deletedObj.dedDeductibleCd){
				existIndex = i;
				break;
				//objDeductibles.splice(i, 1); 
			}
		}
		
		if (existIndex > 0) {
			objDeductibles.splice(existIndex, 1); // removes the object from the array of objects if existing
			objDeductibles.push(deletedObj); // added by mark jm 11.26.2010 push the object to be deleted
		} else {
			objDeductibles.push(deletedObj); // adds the deleted object to the array;
		}
	}catch(e){
		showErrorMessage("addDeletedJSONDeductible", e);
	}	
}