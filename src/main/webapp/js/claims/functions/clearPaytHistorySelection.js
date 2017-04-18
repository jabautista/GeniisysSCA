function clearPaytHistorySelection(){
	$("txtPayeeClassCd").value = null;
	$("txtPayeeClassDesc").value = null;
	$("txtPayeeCd").value = null;
	$("txtPayee").value = null;
	$("txtRemarksHist").value = null;
	disableButton("btnUpdate");
	disableInputField("txtRemarksHist");
	objCurrPaytHistory = {};
}