function createSettlementForReport(obj){
	try{
		new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
			parameters:{
				action: 'createSettlementForReport',
				evalId : obj.evalId,
				claimId: obj.claimId,
				itemNo : obj.itemNo,
				perilCd : obj.perilCd,
				totEstCos : obj.totEstCos,
				vat : mcMainObj.vat
			},								
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Creating Settlement for MC Evaluation Report.."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					showWaitingMessageBox("Settlement has been created.", "S",function(){
						changeTag = 0;
						clearFlags();
						/*populateEvalSumFields(null);
						populateOtherDetailsFields(null);
						toggleEditableOtherDetails(false);*/
						refreshMcEvaluationReport();
					});
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("createSettlementForReport",e);
	}
}