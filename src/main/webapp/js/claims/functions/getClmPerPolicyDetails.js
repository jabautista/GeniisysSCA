/**
 * Populate Claim Listing Per Policy Details (GICLS250)
 * @author niknok
 * @date 12.05.2011
 */
function getClmPerPolicyDetails(){
	try{
		new Ajax.Updater("clmListingPerPolicyDiv2", contextPath+"/GICLClaimsController",{
			parameters:{
				action: "getClaimsPerPolicyDetails",
				lineCd: $F("txtNbtLineCd"),
				sublineCd: $F("txtNbtSublineCd"),
				polIssCd: $F("txtNbtPolIssCd"),
				issueYy: $F("txtNbtIssueYy"),
				polSeqNo: $F("txtNbtPolSeqNo"),
				renewNo: $F("txtNbtRenewNo"),
				assdName: $F("txtNbtAssuredName"),
				clmFileDate: nvl($F("rdoNbtDateType1"),""),
				lossDate: nvl($F("rdoNbtDateType2"),""),
				asOfDate: nvl($F("txtNbtAsOfDate"),getCurrentDate()),
				fromDate: $F("txtNbtFromDate"),
				toDate: $F("txtNbtToDate"),	
				module: "GICLS250"
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					 null;
				}
			}
		});
	}catch(e){
		showErrorMessage("getClmPerPolicyDetails", e);	
	}
}	
