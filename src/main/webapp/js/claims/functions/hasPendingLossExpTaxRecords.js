function hasPendingLossExpTaxRecords(){
	var hasPendingLossExpTax = false;
	hasPendingLossExpTax = getAddedAndModifiedJSONObjects(objGICLLossExpTax).length > 0 || getDeletedJSONObjects(objGICLLossExpTax).length > 0 ? true : false;
	return hasPendingLossExpTax;
}