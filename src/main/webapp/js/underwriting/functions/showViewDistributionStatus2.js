//Joms Diago 04.29.2013
function showViewDistributionStatus2(){
	new Ajax.Updater("dynamicDiv", contextPath+"/GIPIPolbasicController?action=showViewDistributionStatus&refresh=0&branchCd=" + objGipis130.credBranch 
			+ "&lineCd=" + objGipis130.filterLineCd 
			+ objGipis130.distFlag 
			+ objGipis130.dateParams 
			+ objGipis130.dateOpt,{
		method: "POST",
		parameters:{ // added by robert SR 4887 09.18.15
			sublineCd: 	objGIPIS130.details != null ? objGIPIS130.details.sublineCd : objGipis130.filterSublineCd,
			issCd:		objGIPIS130.details != null ? objGIPIS130.details.issCd : objGipis130.filterIssCd,
			issueYy:	objGIPIS130.details != null ? objGIPIS130.details.issueYy : objGipis130.filterIssueYy,
			polSeqNo:	objGIPIS130.details != null ? objGIPIS130.details.polSeqNo : objGipis130.filterPolSeqNo,
			renewNo:	objGIPIS130.details != null ? objGIPIS130.details.renewNo : objGipis130.filterRenewNo,
			objFilter:	objCurrPolicyDS.distNo != null ? "{\"distNo\":"+objCurrPolicyDS.distNo+"}" : ""
		},
		evalScripts: true,
		asynchronous: false,
		onCreate: showNotice("Getting View Distribution Status page, please wait..."),
		onComplete: function () {
			hideNotice();
		}
	});
}