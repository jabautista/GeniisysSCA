/**
 * Populates the redistribution policy information header 
 * with values from a JSON Object
 * @param obj - JSON Array object 
 * 
 */
function populateRedistributionPolicyInfoFields(obj){
	//$("txtPolicyNo").value 			= obj == null ? "" : unescapeHTML2(obj.policyNo); // andrew - 12.5.2012
	// added by andrew - 12.5.2012
	$("txtPolLineCd").value = obj == null ? "" : unescapeHTML2(obj.lineCd);
	$("txtPolSublineCd").value = obj == null ? "" : unescapeHTML2(obj.sublineCd);
	$("txtPolIssCd").value = obj == null ? "" : unescapeHTML2(obj.issCd);
	$("txtPolIssueYy").value = obj == null ? "" : formatNumberDigits(obj.issueYy, 2);
	$("txtPolPolSeqNo").value = obj == null ? "" : formatNumberDigits(obj.polSeqNo, 7);
	$("txtPolRenewNo").value = obj == null ? "" : formatNumberDigits(obj.renewNo, 2);
	
	$("txtPolLineCd").writeAttribute("readonly", "readonly");
	$("txtPolSublineCd").writeAttribute("readonly", "readonly");
	$("txtPolIssCd").writeAttribute("readonly", "readonly");
	$("txtPolIssueYy").writeAttribute("readonly", "readonly");
	$("txtPolPolSeqNo").writeAttribute("readonly", "readonly");
	$("txtPolRenewNo").writeAttribute("readonly", "readonly");
	//end andrew - 12.5.2012
	
	$("txtAssdName").value 			= obj == null ? "" : unescapeHTML2(obj.assdName);
	$("txtEndtNo").value 			= obj == null ? "" : unescapeHTML2(obj.endtNo);
//	$("txtEffDate").value			= obj == null ? "" : (obj.effDate == null ? "" : dateFormat(obj.effDate, "mm-dd-yyyy"));
//	$("txtExpiryDate").value		= obj == null ? "" : (obj.expiryDate == null ? "" : dateFormat(obj.expiryDate, "mm-dd-yyyy"));
	//added by steven 08.08.2014
	$("txtEffDate").value			= obj == null ? "" : obj.strEffDate;
	$("txtExpiryDate").value		= obj == null ? "" : obj.strExpiryDate;
	$("txtRedistributionDate").value= "";
}