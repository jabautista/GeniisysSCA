function checkLOAOverrideRequestExist(obj, requestExists, canvas){
	try{
		if(nvl(obj.claimId, "") == ""){
			showMessageBox("The override request was not created because the claim_id has no value.", "E");
			return false;
		}else if(nvl(obj.clmLossId, "") == ""){
			showMessageBox("The override request was not created because the clm_loss_id has no value.", "E");
			return false;
		}else if(nvl(obj.payeeClassCd, "") == ""){
			showMessageBox("The override request was not created because the payee_type_cd has no value.", "E");
			return false;
		}else if(nvl(obj.payeeCd, "") == ""){
			showMessageBox("The override request was not created because the payee_cd has no value.", "E");
			return false;
		}else{
			new Ajax.Request(contextPath+"/GICLLossExpDtlController", {
				asynchronous: false,
				parameters:{
					action    : "checkLOAOverrideRequestExist",
					claimId	  : objCLMGlobal.claimId,
					evalId	  : obj.evalId,
					clmLossId : obj.clmLossId,
					payeeClassCd : obj.payeeClassCd,
					payeeCd	  : obj.payeeCd
				},
				onCreate: function(){
					showNotice("Processing, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var jsonObj = JSON.parse(response.responseText);
						var recExist = (jsonObj.recExist).toString(); 
						
						if(recExist == "4"){
							enableButton("btnGenerate"+canvas);
							showWaitingMessageBox("There is an existing override request and it was already approved.  You are now allowed to print.", "I",
									               function(){
														enableButton("btnGenerate"+canvas);
														showGenericPrintDialog("Print", function(){}, function(){});
												  });
							overlayOverrideRequest.close();
							delete overlayOverrideRequest;
							
						}else if(recExist == "5"){
							if(nvl(requestExists, "N") == "N"){
								showConfirmBox("Confirmation", "There is an existing override request for the current record that is not yet approved.  Would you like to create a new request?", 
										"Ok", "Cancel", 
										function(){
											createRequestOverride(obj);
										}, 
										function(){
											
										}
								);
							}else{
								createRequestOverride(obj, canvas);
							}
						}else{
							createRequestOverride(obj, canvas);
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});
		}
	}catch(e){
		showErrorMessage("checkLOAOverrideRequestExist", e);	
	}
}