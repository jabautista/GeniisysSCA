function getMcEvalItemTG(obj){
	try{
		new Ajax.Updater("mcEvalItemTGMainDiv", contextPath+"/GICLMcEvaluationController",{
			method: "GET",
			parameters: {
				action: "getMcEvalItemTGList",
				sublineCd: (obj != null ? obj.sublineCd : null),
				issCd: (obj != null ? obj.issCd : null),
				clmYy: (obj != null ? obj.clmYy : null),
				clmSeqNo: (obj != null ? obj.clmSeqNo : null)
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
		showErrorMessage("getMcEvalItemTG",e);
	}
}