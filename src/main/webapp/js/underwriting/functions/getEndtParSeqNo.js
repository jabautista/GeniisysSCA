function getEndtParSeqNo(){
	if ($("globalParSeqNoC") != null && $("inputParSeqNo") != null){
		$("inputParSeqNo").value = $F("globalParSeqNoC");
	}
	$("parId").value = $("globalParId").value;
	$("basicInformation").show();
	$("btnCreateNew").show();
	enableButton("btnSave");
	enableButton("btnCancel");
	//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
}