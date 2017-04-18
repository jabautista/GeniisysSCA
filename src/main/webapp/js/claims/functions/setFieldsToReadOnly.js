function setFieldsToReadOnly(x){
	if(x){
		$("txtNbtLineCd").readOnly = true;
        $("txtNbtSublineCd").readOnly = true;
        $("txtNbtPolIssCd").readOnly = true;
        $("txtNbtIssueYy").readOnly = true;
        $("txtNbtPolSeqNo").readOnly = true; 
        $("txtNbtRenewNo").readOnly = true;
	} else {
		$("txtNbtLineCd").readOnly = false;
        $("txtNbtSublineCd").readOnly = false;
        $("txtNbtPolIssCd").readOnly = false;
        $("txtNbtIssueYy").readOnly = false;
        $("txtNbtPolSeqNo").readOnly = false; 
        $("txtNbtRenewNo").readOnly = false;
	}
	
}