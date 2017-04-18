function updateGiclLossExpDtl(newObj){
	function updateLossExpDtl(){
		newObj.recordStatus = 1;
		replaceLossExpDtlObject(newObj);
		giclLossExpDtlTableGrid.updateVisibleRowOnly(newObj, giclLossExpDtlTableGrid.getCurrentPosition()[1]);
		updateTGPager(giclLossExpDtlTableGrid);
		computeTotalsForLossExpDtl();
		clearLossExpDtlForm();
		updateClmLossExpAmounts();
	}
	
	try{
		new Ajax.Request(contextPath + "/GICLLossExpDtlController", {
			parameters:{
				action: "validateLossExpDtlUpdate",
				claimId: nvl(newObj.claimId, 0),
				clmLossId: nvl(newObj.clmLossId, 0),
				lossExpCd: nvl(newObj.lossExpCd, "")
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(nvl(response.responseText, "EMPTY") != "EMPTY"){
						showConfirmBox("Confirmation", response.responseText, "Yes", "No", 
								function(){updateLossExpDtl();}, function(){});
					}else{
						updateLossExpDtl();
						fireEvent($("btnSave"), "click"); //added by robert GENQA 5027 11.04.15
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("updateGiclLossExpDtl", e);
	}
}