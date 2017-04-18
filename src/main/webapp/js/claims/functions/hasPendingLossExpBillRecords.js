function hasPendingLossExpBillRecords(){
	var hasPendingLossExpBill = false;
	hasPendingLossExpBill = getAddedAndModifiedJSONObjects(objGICLLossExpBill).length > 0 || getDeletedJSONObjects(objGICLLossExpBill).length > 0 ? true : false;
	return hasPendingLossExpBill;
}