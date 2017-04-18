function clearPolicyInfoFields(clearClaimFields){
	$("txtLineCd").value = "";
	$("txtSublineCd").value = "";
	$("txtPolIssCd").value = "";
	$("txtPolIssueYy").value = "";
	$("txtPolSeqNo").value  = "";
	$("txtPolRenewNo").value = "";
	$("textItemNo").value ="";
	$("textItemDesc").value = "";
	$("txtLossDate").value = "";
	$("txtPlateNo").value ="";
	$("txtPerilCd").value = "";
	$("txtPerilName").value = "";
	if(!clearClaimFields){
		$("txtClmSublineCd").value = "";
		$("txtClmIssCd").value ="";
		$("txtClmYy").value = "";
		$("txtClmSeqNo").value = "";
	}
}