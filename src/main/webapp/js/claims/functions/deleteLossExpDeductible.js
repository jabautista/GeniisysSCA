function deleteLossExpDeductible(){
	var delObj = setLossExpDeductibleObject();
	var index = lossExpDeductiblesTableGrid.getCurrentPosition()[1];
	
	function deleteDeductible(){
		for(var i=0; i<objLossExpDeductibles.length; i++){
			var ded = objLossExpDeductibles[i];
			if(parseInt(delObj.claimId) == parseInt(ded.claimId) && 
			   parseInt(delObj.clmLossId) == parseInt(ded.clmLossId) &&
			   delObj.lossExpCd == ded.lossExpCd){
				delObj.recordStatus = -1;
				objLossExpDeductibles.splice(i,1,delObj);
			}
			lossExpDeductiblesTableGrid.deleteVisibleRowOnly(index);
			updateTGPager(lossExpDeductiblesTableGrid);
			populateLossExpDeductibleForm(null);
			computeTotalDeductibleAmt();
		}
	}
	
	try{
		new Ajax.Request(contextPath + "/GICLLossExpDtlController", {
			parameters:{
				action: "validateLossExpDeductibleDelete",
				claimId: nvl(delObj.claimId, 0),
				clmLossId: nvl(delObj.clmLossId, 0),
				dedLossExpCd: nvl(delObj.dedLossExpCd, "")
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
									function(){deleteDeductible();}, function(){});
						}else{
							deleteDeductible();
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
		showErrorMessage("deleteLossExpDeductible", e);
	}
}