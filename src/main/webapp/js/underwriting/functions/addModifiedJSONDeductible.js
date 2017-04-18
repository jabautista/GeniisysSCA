function addModifiedJSONDeductible(editedObj) {
	try{
		editedObj.recordStatus = 1;
		for (var i=0; i<objDeductibles.length; i++) {
			if(objDeductibles[i].itemNo == editedObj.itemNo && objDeductibles[i].perilCd == editedObj.perilCd && objDeductibles[i].dedDeductibleCd == editedObj.dedDeductibleCd){
				objDeductibles.splice(i, 1); // removes the object from the array of objects if existing
			}			
		}
		objDeductibles.push(editedObj); // adds the modified object to the array;
	}catch(e){
		showErrorMessage("addModifiedJSONDeductible", e);
	}	
}