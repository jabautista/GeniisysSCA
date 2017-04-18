function hasPendingClmLossExpRecords(){
	var hasPending = false;
	var hasPendingClmLossExp = false;
	var hasPendingLossExpDtl = false;
	
	hasPendingClmLossExp = getAddedAndModifiedJSONObjects(objGICLClmLossExpense).length > 0 || getDeletedJSONObjects(objGICLClmLossExpense).length > 0 ? true : false;
	hasPendingLossExpDtl = getAddedAndModifiedJSONObjects(objGICLLossExpDtl).length > 0 || getDeletedJSONObjects(objGICLLossExpDtl).length > 0 ? true : false;
	
	if(hasPendingClmLossExp || hasPendingLossExpDtl){
		hasPending = true;
	}
	
	return hasPending;
}