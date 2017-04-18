function validateAdjusterClassCd(payeeClassCd){
	try{
		new Ajax.Request(contextPath+"/GICLClmAdjusterController", {
			asynchronous: false,
			parameters:{
				action: "getLossExpAdjusterList",
				claimId : nvl(objCLMGlobal.claimId, 0)
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var objArray = JSON.parse(response.responseText);
					var length = parseFloat(objArray.length);
					if(length == 1){
						for(var i=0; i<objArray.length; i++){
							checkIfGiclLossPayeesExist(payeeClassCd, objArray[i].adjCompanyCd, objArray[i].dspAdjCoName, "adjusters");
							break;
						}
					}else if(length > 1){
						return true;
					}else{
						showWaitingMessageBox("There is no adjuster assigned for this claim. Please return "+
						"to basic information for the Adjuster assignment.", "I", function(){
							$("payee").value = "";
							$("payee").setAttribute("payeeNo", "");
							$("payeeClass").value = "";
							$("payeeClass").setAttribute("payeeClassCd", "");
						});
						return false;
					}
				}else{
					showMessageBox(response.responseText, "E");
					return false;
				}
			}
		});
	}catch(e){
		showErrorMessage("validateAdjusterClassCd", e);
	}
}