function checkIfToAddLossExpDtl(newObj){
	function addLossExpDtl(){
		giclLossExpDtlTableGrid.addBottomRow(newObj);
		updateTGPager(giclLossExpDtlTableGrid);
		computeTotalsForLossExpDtl();
		clearLossExpDtlForm();
		updateClmLossExpAmounts();
	}
	
	try{
		new Ajax.Request(contextPath + "/GICLLossExpDtlController", {
			parameters:{
				action: "validateLossExpDtlAdd",
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
					if(checkErrorOnResponse(response)){
						if(nvl(response.responseText, "EMPTY") != "EMPTY"){
							showConfirmBox("Confirmation", response.responseText, "Yes", "No", 
									function(){addLossExpDtl();}, function(){clearLossExpDtlForm();});
						}else{
							addLossExpDtl();
							fireEvent($("btnSave"), "click"); //Added by Kenneth 05.26.2015 SR 3625
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("checkIfToAddLossExpDtl", e);
	}
}