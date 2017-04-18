function cancelMcEvalreport(){
	try{
		new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
			parameters:{
				action: "cancelMcEvalreport",
				selectedMcEvalObj: prepareJsonAsParameter(selectedMcEvalObj)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Cancelling MC Evaluation Report.."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					showMessageBox(objCommonMessage.SUCCESS, "S");
					changeTag = 0;
					clearFlags();
					/*populateEvalSumFields(null);
					populateOtherDetailsFields(null);
					toggleEditableOtherDetails(false);
					mcEvalGrid.refresh();
					toggleButtons(null);*/
					refreshMcEvaluationReport();
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("cancelMcEvalreport",e);
	}
}