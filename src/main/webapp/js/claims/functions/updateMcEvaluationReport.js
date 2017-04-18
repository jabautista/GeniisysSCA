function updateMcEvaluationReport(){
	try{
		//added by robert 7.23.2013
		if(selectedMcEvalObj.evalStatCd == "PD"){
			showMessageBox("Evaluation details cannot be updated. Record is already posted.", imgMessage.INFO);
			valid =false;
		}
		var objParameters = {};
		objParameters.mcMainObj = mcMainObj;
		objParameters.varMcMainObj = varMcMainObj;
		new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
			parameters:{
				action: "updateMcEvaluationReport",
				evalId: selectedMcEvalObj.evalId,
				remarks : escapeHTML2($F("remarks")),
				inspectDate : $F("inspectDate"),
			    adjusterId : $F("clmAdjId"),
				inspectPlace : escapeHTML2($F("inspectPlace")),
				parameters: JSON.stringify(objParameters)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Saving MC Evaluation Report.."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					varMcMainObj.plateNo = mcMainObj.plateNo; // holds orig values of mcMainObj for masterBlk key commit
					varMcMainObj.itemNo = mcMainObj.itemNo;
					varMcMainObj.perilCd = mcMainObj.perilCd;
					varMcMainObj.tpSw = mcMainObj.tpSw;
					varMcMainObj.payeeClassCd = mcMainObj.payeeClassCd;
					varMcMainObj.payeeNo = mcMainObj.payeeNo;
					//showMessageBox(objCommonMessage.SUCCESS, "S");
					changeTag = 0;
					clearFlags();
					/*populateEvalSumFields(null);
					populateOtherDetailsFields(null);
					toggleEditableOtherDetails(false);*/
					hideNotice("");
					showWaitingMessageBox(objCommonMessage.SUCCESS,"S", refreshMcEvaluationReport);
					//refreshMcEvaluationReport();//mcEvalGrid.refresh();
				//	toggleButtons(null);
					
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("updateMcEvaluationReport",e);
	}
}