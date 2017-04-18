function deleteGiclLossExpDtl(){
	var index = giclLossExpDtlTableGrid.getCurrentPosition()[1];
	var delObj = setGiclLossExpDtlObject();
	
	function deleteLossExpDtl(){
		delObj.recordStatus = -1;
		replaceLossExpDtlObject(delObj);
		giclLossExpDtlTableGrid.deleteVisibleRowOnly(index);
		clearLossExpDtlForm();
		computeTotalsForLossExpDtl();
		updateClmLossExpAmounts();
	}
	
	try{
		new Ajax.Request(contextPath + "/GICLLossExpDtlController", {
			parameters:{
				action: "validateLossExpDtlDelete",
				claimId: nvl(delObj.claimId, 0),
				clmLossId: nvl(delObj.clmLossId, 0),
				lossExpCd: nvl(delObj.lossExpCd, "")
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "EMPTY") != "EMPTY"){
						showConfirmBox("Confirm Delete", response.responseText, "Yes", "No", 
								function(){deleteLossExpDtl();}, function(){});
					}else{
						deleteLossExpDtl();
						fireEvent($("btnSave"), "click"); //added by robert GENQA 5027 11.04.15
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("deleteGiclLossExpDtl", e);
	}
}