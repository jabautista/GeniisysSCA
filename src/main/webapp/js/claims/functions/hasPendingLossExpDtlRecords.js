function hasPendingLossExpDtlRecords(){
	var hasPendingLossExpDtl = false;
	if(changeTag == 1){ //added by robert GENQA 5027 11.04.15
		hasPendingLossExpDtl = getAddedAndModifiedJSONObjects(objGICLLossExpDtl).length > 0 || getDeletedJSONObjects(objGICLLossExpDtl).length > 0 ? true : false;
	}
	return hasPendingLossExpDtl;
}