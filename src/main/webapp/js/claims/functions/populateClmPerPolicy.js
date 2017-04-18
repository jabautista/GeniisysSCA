/**
 * Populate Claim Listing Per Policy (GICLS250)
 * @author niknok
 * @date 12.05.2011
 */
function populateClmPerPolicy(obj){
	try{
		$("txtNbtLineCd").value 			= nvl(obj,null) == null ? null :nvl(obj.lineCode,"");
		$("txtNbtSublineCd").value 			= nvl(obj,null) == null ? null :nvl(obj.sublineCd,"");
		$("txtNbtPolIssCd").value 			= nvl(obj,null) == null ? null :nvl(obj.policyIssueCode,"");
		$("txtNbtIssueYy").value 			= nvl(obj,null) == null ? null :nvl(String(obj.issueYy),null) != null ? Number(obj.issueYy).toPaddedString(2) :null;
		$("txtNbtPolSeqNo").value 			= nvl(obj,null) == null ? null :nvl(String(obj.policySequenceNo),null) != null ? Number(obj.policySequenceNo).toPaddedString(7) :null;
		$("txtNbtRenewNo").value 			= nvl(obj,null) == null ? null :nvl(String(obj.renewNo),null) != null ? Number(obj.renewNo).toPaddedString(2) :null;
		$("txtNbtAssuredName").value 		= nvl(obj,null) == null ? null :unescapeHTML2((obj.assuredName == null ? "" : obj.assuredName));
		getClmPerPolicyDetails();
	}catch(e){
		showErrorMessage("populateClmPerPolicy", e);	
	}	
}	