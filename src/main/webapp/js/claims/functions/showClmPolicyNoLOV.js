/**
 * Shows Policy No. lov in GICLS250
 * @author niknok
 * @date 12.05.2011
 */
function showClmPolicyNoLOV(){
	var objFilter = {};
	objFilter.assuredName = $F("txtNbtAssuredName");
	overlayClmPolicyNoLOV = Overlay.show(contextPath+"/GICLClaimsController", {
		urlContent: true,
		urlParameters: {action : "showClmPolicyNoLOV", 
						lineCd: $F("txtNbtLineCd"),
						sublineCd: $F("txtNbtSublineCd"),
						polIssCd: $F("txtNbtPolIssCd"),
						issueYy: $F("txtNbtIssueYy"),
						polSeqNo: $F("txtNbtPolSeqNo"),
						renewNo: $F("txtNbtRenewNo"), 
						objFilter : (nvl($F("txtNbtAssuredName"),"") == "" ? "" : JSON.stringify(objFilter)),
						module: "GICLS250"
						},
		title: "Policy Nos.",	
		id: "clm_policy_no_listing_view",
		width: 525,
		height: 385,
	    draggable: false
	});
}