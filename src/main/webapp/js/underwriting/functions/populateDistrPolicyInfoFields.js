/**
 * Populates the policy information header 
 * with values from a JSON Object
 * @param obj - JSON Array object 
 * 
 */
function populateDistrPolicyInfoFields(obj){
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
	$("txtDistNo").value 			= obj == null ? "" : formatNumberDigits(obj.distNo, 8);
	$("txtDistFlag").value 			= obj == null ? "" : obj.distFlag;
	$("txtMeanDistFlag").value 		= obj == null ? "" : unescapeHTML2(obj.meanDistFlag);
	
	// hidden fields, other columns (emman 07.21.2011)
	if ($("txtPolDistV1LineCd") != null || $("txtPolDistV1LineCd") != undefined) {
		$("txtPolDistV1LineCd").value	= obj == null ? "" : unescapeHTML2(obj.lineCd);
	}
	
	//nok
	$("txtMultiBookingMm").value = obj == null ? "" : unescapeHTML2(obj.multiBookingMm);
	$("txtMultiBookingYy").value = obj == null ? "" : unescapeHTML2(obj.multiBookingYy);
}