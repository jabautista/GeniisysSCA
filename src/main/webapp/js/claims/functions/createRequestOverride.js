function createRequestOverride(obj, canvas, fromMcEval){// added parameter fromMcEval, irwin - may 10, 2012
	
	try{
		new Ajax.Request(contextPath+"/GICLLossExpDtlController", {
			asynchronous: false,
			parameters:{
				action    : "createLOAOverrideRequest",
				claimId	  : fromMcEval == "Y" ? mcMainObj.claimId : objCLMGlobal.claimId,
				evalId	  : obj.evalId,
				clmLossId : obj.clmLossId,
				payeeClassCd : fromMcEval == "Y" ? obj.payeeTypeCd : obj.payeeClassCd,
				payeeCd	  : obj.payeeCd,
				remarks   : $("txtOverrideRequestRemarks").value,
				issCd	  : fromMcEval == "Y" ? mcMainObj.issCd : objCLMGlobal.issueCode,
				lineCd	  : fromMcEval == "Y" ? mcMainObj.lineCd :objCLMGlobal.lineCode,
				canvas	  : canvas
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						showWaitingMessageBox("Override request was succesfully created.", "I", function(){
							enableButton("btnGenerate"+canvas);
							overlayOverrideRequest.close();
							delete overlayOverrideRequest;
						});
					}else{
						showMessageBox(response.responseText, "E");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
				
			}
		});
	}catch(e){
		showErrorMessage("checkLOAOverrideRequestExist", e);	
	}
}