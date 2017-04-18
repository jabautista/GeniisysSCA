function intFieldsAreNotNan(){
	result = true;
	$$("input[ name='intField']").each(function(field){
		if ((field.value != "") && (isNaN(field.value))){
			result = false;
		}
	});
	if (!result){
		showMessageBox("Invalid number in example record. Query not issued.", imgMessage.ERROR);
	}
	return result;
}