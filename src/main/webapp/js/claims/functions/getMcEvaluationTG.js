function getMcEvaluationTG(obj){
	try{
		new Ajax.Updater("mcEvaluationTGMainDiv", contextPath+"/GICLMcEvaluationController",{
			method: "GET",
			parameters: {
				action: "getMcEvaluationTGList",
				claimId: (obj != null ? obj.claimId : null),
				itemNo: (obj != null ? obj.itemNo : null),
				payeeNo: (obj != null ? obj.payeeNo : null),
				payeeClassCd: (obj != null ? obj.payeeClassCd : null),
				plateNo: (obj != null ? obj.plateNo : null),
				perilCd: (obj != null ? obj.perilCd : null),
				polLineCd: (obj != null ? obj.polLineCd : null),
				polSublineCd: (obj != null ? obj.polSublineCd : null),
				polIssCd: (obj != null ? obj.polIssCd : null),
				polIssueYy: (obj != null ? obj.issueYy : null),
				polRenewNo: (obj != null ? obj.renewNo : null)
			},
			asynchrous: true,
			evalScripts: true,
			onCreate : function() {
				showNotice("Getting list, please wait...");
			},
			onComplete: function (response){
				hideNotice();
			}
		});
		
	}catch (e) {
		showErrorMessage("getMcEvaluationTG",e);
	}
}