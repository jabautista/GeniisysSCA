function hasPendingLossExpDeductibleRecords(){
	var hasPendingLossExpDeductible = false;
	hasPendingLossExpDeductible = getAddedAndModifiedJSONObjects(objLossExpDeductibles).length > 0 || getDeletedJSONObjects(objLossExpDeductibles).length > 0 ? true : false;
	return hasPendingLossExpDeductible;
}