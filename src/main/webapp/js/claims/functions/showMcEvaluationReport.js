function showMcEvaluationReport(mode){
	try{
		if("itemInfo" == mode){
			mcEvalFromItemInfo = "Y";
			new Ajax.Updater("basicInformationMainDiv", contextPath + "/GICLMcEvaluationController?action=showMcEvaluationReport", {
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
					$("txtClmSublineCd").value = objCLMGlobal.sublineCd;
					$("txtClmIssCd").value = objCLMGlobal.issCd;
					$("txtClmYy").value = objCLMGlobal.claimYy;
					$("txtClmSeqNo").value = lpad(objCLMGlobal.claimSequenceNo, 7, "0");
					getEvalPolInfo(objCLMGlobal.sublineCd,objCLMGlobal.issCd,objCLMGlobal.claimYy,objCLMGlobal.claimSequenceNo);
				}
			});
		}else{
			objCLMGlobal.callingForm = "GICLS070"; 
			updateMainContentsDiv("/GICLMcEvaluationController?action=showMcEvaluationReport",
			"Getting MC Evaluation Report, please wait...");
			$("mainNav").hide();
		}
		
	}catch(e){
		showErrorMessage("showMcEvaluationReport",e);
	}
}