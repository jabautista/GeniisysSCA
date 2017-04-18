function resetAllLossExpHistObjects(){
	resetObjectRecords(objGICLLossExpPayees);
	resetObjectRecords(objGICLClmLossExpense);
	resetObjectRecords(objGICLLossExpDtl);
	$("hidNextClmLossId").value = $("hidMaxClmLossId").value;
}