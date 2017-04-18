function checkLossExpenseChanges(func){
	if(changeTag == 1 || checkLossExpChildRecords()){
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}else{
		func();
	}
}