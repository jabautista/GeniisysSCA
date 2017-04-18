function enableParCreationButtons(riFlag){
	if(riFlag != "Y") {
		enableButton("btnSelectQuotation");
		enableButton("btnReturnToQuotation");
	}
	enableButton("btnAssuredMaintenance");
	enableButton("btnCancel");
	enableButton("btnSave");
}