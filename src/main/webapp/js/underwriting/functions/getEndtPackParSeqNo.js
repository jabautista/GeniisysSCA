function getEndtPackParSeqNo(){
	try{
		if($("globalParSeqNo").value != null && $("parSeqNo") != null){
			$("parSeqNo").value = $("globalParSeqNo").value == "" ? "" : parseInt($("globalParSeqNo").value).toPaddedString(4); 
		}
		$("packBasicInformation").show();
		$("endtPackLineCd").disable();
		$("endtIssueSource").disable();
		$("year").readOnly = true;
		$("btnCreateNew").show();
		enableButton("btnCreateNew");
		$("packParId").value = $("globalPackParId").value;
		
		showMessageBox("Saving Successful.", imgMessage.SUCCESS);
		
	}catch(e){
		showErrorMessage("getEndtPackParSeqNo", e);
	}

}