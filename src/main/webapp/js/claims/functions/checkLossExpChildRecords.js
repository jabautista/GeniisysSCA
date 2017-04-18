function checkLossExpChildRecords(){
	var hasPending = false;
	var hasPendingPayee = false;
	var hasPendingClmLossExp = false;
	var hasPendingLossExpDtl = false;
	
	hasPendingPayee = getAddedAndModifiedJSONObjects(objGICLLossExpPayees).length > 0 || getDeletedJSONObjects(objGICLLossExpPayees).length > 0 ? true : false;
	hasPendingClmLossExp = getAddedAndModifiedJSONObjects(objGICLClmLossExpense).length > 0 || getDeletedJSONObjects(objGICLClmLossExpense).length > 0 ? true : false;
	hasPendingLossExpDtl = getAddedAndModifiedJSONObjects(objGICLLossExpDtl).length > 0 || getDeletedJSONObjects(objGICLLossExpDtl).length > 0 ? true : false;
	
	if(hasPendingPayee || hasPendingClmLossExp || hasPendingLossExpDtl){
		hasPending = true;
	}
	
	return hasPending;
}