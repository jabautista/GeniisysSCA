//bonok :: 11.08.2013 :: for inquiry
function showMcEvaluation(){
	try{
		new Ajax.Updater("mcEvaluationReportInquiryDiv", contextPath + "/GICLMcEvaluationController?action=showMcEvaluationReportInquiry", {
			method: "GET",
			parameters: {
			//	claimId: objCLMGlobal.claimId,
				//lineCd: objCLMGlobal.lineCd
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				//showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				//hideNotice();
				objCLMGlobal.callingForm = "GICLS260"; 
				$("txtClmSublineCd").value = objCLMGlobal.sublineCd;
				$("txtClmIssCd").value = objCLMGlobal.issCd;
				$("txtClmYy").value = objCLMGlobal.claimYy;
				$("txtClmSeqNo").value = objCLMGlobal.claimSequenceNo;
				getEvalPolInfo(objCLMGlobal.sublineCd,objCLMGlobal.issCd,objCLMGlobal.claimYy,objCLMGlobal.claimSequenceNo);
			}
		});
	}catch(e){
		showErrorMessage("showMcEvaluationReport",e);
	}
}