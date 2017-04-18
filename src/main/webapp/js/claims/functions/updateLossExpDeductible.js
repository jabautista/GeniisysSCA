function updateLossExpDeductible(newObj){
	function updateDeductible(){
		for(var i=0; i<objLossExpDeductibles.length; i++){
			var ded = objLossExpDeductibles[i];
			if(parseInt(newObj.claimId) == parseInt(ded.claimId) && 
			   parseInt(newObj.clmLossId) == parseInt(ded.clmLossId) &&
			   newObj.lossExpCd == ded.lossExpCd){
				newObj.recordStatus = 1;
				objLossExpDeductibles.splice(i,1,newObj);
				lossExpDeductiblesTableGrid.updateVisibleRowOnly(newObj, lossExpDeductiblesTableGrid.getCurrentPosition()[1]);
				populateLossExpDeductibleForm(null);
				computeTotalDeductibleAmt();
			}
		}
	}
	
	try{
		new Ajax.Request(contextPath + "/GICLLossExpDtlController", {
			parameters:{
				action: "validateLossExpDeductibleUpdate",
				claimId: nvl(newObj.claimId, 0),
				clmLossId: nvl(newObj.clmLossId, 0),
				lossExpCd: nvl(newObj.lossExpCd, ""),
				dedLossExpCd: nvl(newObj.dedLossExpCd, "")
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
									function(){
										updateDeductible();
										showMessageBox("Please save record for changes to take effect.");
									}, function(){});
						}else{
							updateDeductible();
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
		showErrorMessage("updateLossExpDeductible", e);
	}
}