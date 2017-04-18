function enableDisableFieldsGiacs007(){
	/*
	if (objACGlobal.orFlag != 'N'){
		$("tranType").disabled = true;
		disableButton("btnAdd");
		disableButton("btnDelete");
		disableButton("btnDatedCheck");
		disableButton("btnUpdate");
		disableButton("btnSpecUpdate");
	}
	*/
	if (objAC.tranFlagState != 'O' || objACGlobal.orStatus == "CANCELLED"
		|| objAC.butLabel == "Cancel OR"){
		$("tranType").disabled = true;
		disableButton("btnAdd");
		disableButton("btnDelete");
		disableButton("btnDatedCheck");
		disableButton("btnUpdate");
		disableButton("btnSpecUpdate");		
	}
}