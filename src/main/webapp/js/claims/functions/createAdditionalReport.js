function createAdditionalReport(masterEvalId){
	try{
		var objParameters = {};
		var newEval = {};
		var extraParam = {};
		newEval.remarks = "";
		newEval.inspectDate = "";
		newEval.dspAdjusterDesc = "";
		newEval.adjusterId = "";
		newEval.inspectPlace = "";
		
		mcMainObj.clmIssCd = $F("txtClmIssCd");
		mcMainObj.clmSublineCd = $F("txtClmSublineCd");
		extraParam.newRepFlag = $F("newRepFlag");
		extraParam.copyDtlFlag = $F("copyDtlFlag");
		extraParam.reviseFlag = $F("reviseFlag");
		
		extraParam.evalMasterId = masterEvalId;
		extraParam.evalStatCd = "IP";
		extraParam.reportType = "AD";
		extraParam.replaceAmt = "";
		extraParam.repairAmt = "";
		
		objParameters.extraParam = prepareJsonAsParameter(extraParam);
		objParameters.mcMainObj = mcMainObj;
		objParameters.newEval = prepareJsonAsParameter(newEval);
		objParameters.varMcMainObj = varMcMainObj;
		
		new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
			parameters:{
				action: "saveMCEvaluationReport",
				parameters: JSON.stringify(objParameters)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Saving MC Evaluation Report.."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S",function(){
						changeTag = 0;
						clearFlags();
						/*populateEvalSumFields(null);
						populateOtherDetailsFields(null);
						toggleEditableOtherDetails(false);*/
						refreshMcEvaluationReport();//mcEvalGrid.refresh();
					});
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	

	}catch(e){
		showErrorMessage("createAdditionalReport",e);
	}
}