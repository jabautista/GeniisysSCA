function checkIfLossExpDeductibleExists(newObj){
	var exist = false;
	for(var i=0; i<objLossExpDeductibles.length; i++){
		var ded = objLossExpDeductibles[i];
		if(parseInt(newObj.claimId) == parseInt(ded.claimId) && 
		   parseInt(newObj.clmLossId) == parseInt(ded.clmLossId) &&
		   newObj.lossExpCd == ded.lossExpCd){
			exist = true;
		}
	}
	return exist;
}