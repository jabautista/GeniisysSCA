function validateBeforePostMap(){
	try{
		showConfirmBox("Post Report","Are you sure you want to post this report?","Yes","No",function(){
			new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
				parameters:{
					action: "validateBeforePostMap",
					claimId: selectedMcEvalObj.claimId,
					itemNo : selectedMcEvalObj.itemNo,
					perilCd : selectedMcEvalObj.perilCd,
					evalId : selectedMcEvalObj.evalId,
					issCd : mcMainObj.issCd
				},								
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Validating MC Evaluation Report.."),
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						hideNotice("");
						var message = response.responseText.toQueryParams();
						variablesObj.resAmt = message.resAmt;
						if(message.pMessage != ""){
							if(message.pMessage  == "Show override"){
								variablesObj.vOverrideProc = "R";
								hideNotice("");
								genericObjOverlay = Overlay.show(contextPath+"/GICLMcEvaluationController", { 
									urlContent: true,
									urlParameters: {action : "showOverrideUserMCEval",
													ajax : "1"},
									title: "Override User",							
								    height: 130,
								    width: 400,
								    draggable: true
								});	 
							}else{
								//showMessageBox(message, "I");
								showMessageBox(message.pMessage, "I"); //marco - 03.27.2014
							}
						}else{
							postEvalReport(selectedMcEvalObj);
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});
		},null);
	}catch(e){
		showErrorMessage("validateBeforePostMap",e);
	}
}