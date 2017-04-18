function populatePrelimLossInfo(){
	$("claimNo").value = unescapeHTML2(objCLM.prelimLossInfo.claimNumber == null ? "" : objCLM.prelimLossInfo.claimNumber);
	$("policyNo").value = unescapeHTML2(objCLM.prelimLossInfo.policyNo == null ? "" : objCLM.prelimLossInfo.policyNo);
	$("assdName").value = unescapeHTML2(objCLM.prelimLossInfo.assuredName == null ? "" : objCLM.prelimLossInfo.assuredName);
	$("address").value = unescapeHTML2(objCLM.prelimLossInfo.billAddress == null ? "" : objCLM.prelimLossInfo.billAddress);
	$("issueDate").value = unescapeHTML2(objCLM.prelimLossInfo.prelimIssueDate == null ? "" : objCLM.prelimLossInfo.prelimIssueDate);
	$("fromTerm").value = unescapeHTML2(objCLM.prelimLossInfo.prelimInceptDate == null ? "" : objCLM.prelimLossInfo.prelimInceptDate);
	$("toTerm").value = unescapeHTML2(objCLM.prelimLossInfo.prelimExpiryDate == null ? "" : objCLM.prelimLossInfo.prelimExpiryDate);
	//$("agent").value = unescapeHTML2(objCLM.prelimLossInfo.intmName == null ? "" : objCLM.prelimLossInfo.intmName); //marco - 04.12.2013
	$("category").value = unescapeHTML2(objCLM.prelimLossInfo.lossCatDes == null ? "" : objCLM.prelimLossInfo.lossCatDes);
	$("dateOfLoss").value = unescapeHTML2(objCLM.prelimLossInfo.prelimLossDate == null ? "" : objCLM.prelimLossInfo.prelimLossDate);
	$("dateReported").value = unescapeHTML2(objCLM.prelimLossInfo.prelimClmFileDate == null ? "" : objCLM.prelimLossInfo.prelimClmFileDate);
	$("placeOfLoss1").value = unescapeHTML2(objCLM.prelimLossInfo.lossLocation1 == null ? "" : objCLM.prelimLossInfo.lossLocation1);
	$("placeOfLoss2").value = unescapeHTML2(objCLM.prelimLossInfo.lossLocation2 == null ? "" : objCLM.prelimLossInfo.lossLocation2);
	$("placeOfLoss3").value = unescapeHTML2(objCLM.prelimLossInfo.lossLocation3 == null ? "" : objCLM.prelimLossInfo.lossLocation3);
	//$("mortgagee").value = unescapeHTML2(objCLM.prelimLossInfo.mortgName == null ? "" : objCLM.prelimLossInfo.mortgName); //marco - 04.12.2013
}