function saveDepreciationDtls(){
	try{
		var objParameters = {};
		objParameters.setRows 	= getAddedAndModifiedJSONObjects(giclEvalDepDtlTGArrObj);
		objParameters.evalId = selectedMcEvalObj.evalId;
		objParameters.total = unformatNumber($F("total"));
		var strParameters = JSON.stringify(objParameters);
		new Ajax.Request(contextPath + "/GICLEvalDepDtlController", {
			parameters:{
				action: "saveDepreciationDtls",
				strParameters: strParameters
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					if(response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS,"S", function(){
							changeTag = 0;
							hasSaved = "Y";
							genericObjOverlay.close();
							showMcEvalDepreciationDetails();
						});	
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			}		
		});
	}catch (e) {
		showErrorMessage("saveDepreciationDtls",e);
	}
}