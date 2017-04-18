/**
 * Description - loding the policies information 
 * 				 into the textfields
 * created by  - mosesBC
 * added claimId - 7.30.2012 - irwin
 */
function loadPolicy(policy,claimId){ // modified by j.diago 05.22.2012 : added unescapeHTML2
	$("txtLineCd").value 			= unescapeHTML2(policy.lineCd);
	$("txtSublineCd").value 		= unescapeHTML2(policy.sublineCd); 
	$("txtIssCd").value 			= unescapeHTML2(policy.issCd);
	$("txtIssueYy").value 			= policy.issueYy;
	$("txtPolSeqNo").value		 	= formatNumberDigits(policy.polSeqNo, 7);
	$("txtRenewNo").value 			= formatNumberDigits(policy.renewNo, 2);
	$("txtRefPolNo").value	 		= unescapeHTML2(policy.refPolNo);
	$("txtDspInceptDate").value 	= policy.inceptDate;
	$("txtDspExpiryDate").value 	= policy.expiryDate;
	$("txtNbtLineCd").value 		= unescapeHTML2(policy.nbtLineCd);
	$("txtNbtIssCd").value 			= unescapeHTML2(policy.nbtIssCd);
	$("txtNbtParYy").value 			= policy.parYy;
	$("txtNbtParSeqNo").value 		= formatNumberDigits(policy.parSeqNo, 6);
	$("txtNbtQuoteSeqNo").value 	= formatNumberDigits(policy.quoteSeqNo, 2);
	$("txtIssueDate").value 		= policy.issueDate;
	$("txtDspAssdNo").value 		= formatNumberDigits(policy.assdNo, 7);
	$("txtDspAssdName").value 		= unescapeHTML2(policy.assdName);
	$("txtDspMeanPolFlag").value 	= policy.meanPolFlag;
	$("txtLineCdRn").value 			= unescapeHTML2(policy.lineCdRn);
	$("txtIssCdRn").value 			= unescapeHTML2(policy.issCdRn);
	$("txtRnYy").value 				= policy.rnYy;
	$("txtRnSeqNo").value 			= policy.rnSeqNo;
	$("txtCreditBranch").value 		= unescapeHTML2(policy.credBranch);
	$("lblPackPolNo").innerHTML 	= policy.packPolNo;
	
	if(policy.lineCd == "SU"){
		$("tdPolicyNoLabel").innerHTML  = "Bond No.";
		$("tdAssuredLabel").innerHTML	= "Principal";
	}else{
		$("tdPolicyNoLabel").innerHTML  = "Policy No.";
		$("tdAssuredLabel").innerHTML	= "Assured";
	}
	if(policy.packPolNo != null){
		$("lblPackPol").setStyle('opacity:1;');
		$("lblPackPolNo").setStyle('opacity:1;');
	}
}