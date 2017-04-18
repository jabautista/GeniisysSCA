function postEvalReport(obj){
	try{
		new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
			parameters:{
				action: 'postEvalReport',
				evalId : selectedMcEvalObj.evalId,
				claimId: selectedMcEvalObj.claimId,
				itemNo : selectedMcEvalObj.itemNo,
				perilCd : selectedMcEvalObj.perilCd,
				currencyCd : selectedMcEvalObj.currencyCd,
				currencyRate : mcMainObj.currencyRate,
				remarks : escapeHTML2($F("remarks")),
				inspectDate : $F("inspectDate"),
			    adjusterId : $F("clmAdjId"),
				inspectPlace : escapeHTML2($F("inspectPlace"))
			},								
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Posting MC Evaluation Report.."),
			onComplete: function(response){
				hideNotice("");
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					showWaitingMessageBox("Report has been posted.", "S",function(){
						showConfirmBox("Create Settlement","Do you want to create a settlement for this report?","Yes","No",function(){
							createSettlementForReport(selectedMcEvalObj);
						},function(){
							changeTag = 0;
							clearFlags();
							/*populateEvalSumFields(null);
							populateOtherDetailsFields(null);
							toggleEditableOtherDetails(false);
							mcEvalGrid.refresh();*/
							refreshMcEvaluationReport();
						});
					});
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("postEvalReport",e);
	}
}