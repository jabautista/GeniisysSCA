function applyDepreciation(){
	try{
		function proceedApply(){
			new Ajax.Request(contextPath + "/GICLEvalDepDtlController", {
				parameters:{
					action: "applyDepreciation",
					evalId: selectedMcEvalObj.evalId,
					clmSublineCd : mcMainObj.sublineCd,
					polSublineCd: mcMainObj.polSublineCd,
					claimId: selectedMcEvalObj.claimId,
					payeeNo: mcMainObj.payeeNo,
					payeeClassCd: mcMainObj.payeeClassCd,
					tpSw: selectedMcEvalObj.tpSw,
					mainEvalVatExist:selectedMcEvalObj.mainEvalVatExist
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						var res = response.responseText;
						if(res == "SUCCESS"){
							showMessageBox("Depreciation Applied.", "S");
							genericObjOverlay.close();
							if(hasSaved == "Y"){
								refreshMainMcEvalList();
							}
						}else{
							showMessageBox(res, "E");
						}
						
					}else{
						showMessageBox(response.responseText, "E");
					}
				}		
			});				
		}
		if(selectedMcEvalObj.mainEvalVatExist == "Y"){
			showConfirmBox("Vat Exist", "The report to which this detail is under already has Tax/es. Updating this record will detele the Tax/es. Do You want to continue?",
				"Yes","No",proceedApply, null		
			);
		}else{
			proceedApply();
		}
	}catch (e) {
		showErrorMessage("applyDepreciation",e);	
	}
}