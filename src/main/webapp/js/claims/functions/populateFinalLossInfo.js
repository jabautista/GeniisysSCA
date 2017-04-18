function populateFinalLossInfo(){
	$("claimNo").value = unescapeHTML2(objCLM.finalLossInfo.claimNumber == null ? "" : objCLM.finalLossInfo.claimNumber);
	$("policyNo").value = unescapeHTML2(objCLM.finalLossInfo.policyNo == null ? "" : objCLM.finalLossInfo.policyNo);
	$("assdName").value = unescapeHTML2(objCLM.finalLossInfo.assuredName == null ? "" : objCLM.finalLossInfo.assuredName);
	$("address").value = unescapeHTML2(objCLM.finalLossInfo.billAddress == null ? "" : objCLM.finalLossInfo.billAddress);
	$("issueDate").value = unescapeHTML2(objCLM.finalLossInfo.prelimIssueDate == null ? "" : objCLM.finalLossInfo.prelimIssueDate);
	$("fromTerm").value = unescapeHTML2(objCLM.finalLossInfo.prelimInceptDate == null ? "" : objCLM.finalLossInfo.prelimInceptDate);
	$("toTerm").value = unescapeHTML2(objCLM.finalLossInfo.prelimExpiryDate == null ? "" : objCLM.finalLossInfo.prelimExpiryDate);
	$("agent").value = unescapeHTML2(objCLM.finalLossInfo.intmName == null ? "" : objCLM.finalLossInfo.intmName);
	$("category").value = unescapeHTML2(objCLM.finalLossInfo.lossCatDes == null ? "" : objCLM.finalLossInfo.lossCatDes);
	$("dateOfLoss").value = unescapeHTML2(objCLM.finalLossInfo.prelimLossDate == null ? "" : objCLM.finalLossInfo.prelimLossDate);
	$("dateReported").value = unescapeHTML2(objCLM.finalLossInfo.prelimClmFileDate == null ? "" : objCLM.finalLossInfo.prelimClmFileDate);
	$("placeOfLoss1").value = unescapeHTML2(objCLM.finalLossInfo.lossLocation1 == null ? "" : objCLM.finalLossInfo.lossLocation1);
	$("mortgagee").value = unescapeHTML2(objCLM.finalLossInfo.mortgName == null ? "" : objCLM.finalLossInfo.mortgName);
	$("adviceId").value = objCLM.finalLossInfo.adviceId == null ? "" : objCLM.finalLossInfo.adviceId;
	$("adviceNo").value = unescapeHTML2(objCLM.finalLossInfo.adviceNo == null ? "" : objCLM.finalLossInfo.adviceNo);
}