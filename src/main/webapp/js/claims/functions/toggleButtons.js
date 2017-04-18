/**
Description: "LOAD" Program Unit in GICL_MC_EVALUATION Module
*/
function toggleButtons(obj){
	try{
		
		if(obj ==null){
			disableButton("btnReplaceDetails");
			disableButton("btnRepairDetails");
			disableButton("btnVehicleInformation");
			disableButton("btnCSL");
			disableButton("btnPostReport");
			disableButton("btnApplyDeductibles");
			disableButton("btnApplyDepreciation");
			disableButton("btnVatDetails");
			disableButton("btnLOA");
			disableButton("btnAdditionalReport");
			disableButton("btnDeductibleDetails");
			disableButton("btnDepreciationDetails");
			disableButton("btnCancelReport");
			disableButton("btnPrintEvaluationSheet");
			disableButton("btnReviseReport");
	
		}else{
			enableButton("btnReplaceDetails");
			enableButton("btnRepairDetails");
			enableButton("btnVehicleInformation");
			enableButton("btnCSL");
			enableButton("btnPostReport");
			enableButton("btnApplyDeductibles");
			enableButton("btnApplyDepreciation");
			enableButton("btnVatDetails");
			enableButton("btnLOA");
			enableButton("btnAdditionalReport");
			enableButton("btnDeductibleDetails");
			enableButton("btnDepreciationDetails");
			enableButton("btnCancelReport");
			enableButton("btnPrintEvaluationSheet");
			enableButton("btnReviseReport");
			variablesObj.evalStatCd = obj.evalStatCd;
			if(obj.evalStatCd == 'CC' || obj.evalStatCd == 'PD'){
				  
				toggleEditableOtherDetails(false);
				variablesObj.mcEvalAllowUpdate = "N";
				variablesObj.giclReplaceAllowupdate = "N";
				variablesObj.giclRepairHdrAllowUpdate = "N";
				variablesObj.giclEvalVatAllowUpdate = "N";
				variablesObj.giclRepairLpsDtlAllowUpdate ="N";
				variablesObj.giclRepairLpsDtlCtrlAllowUpdate ="N";
				variablesObj.giclRepairOtherDtlAllowUpdate = "N";
				variablesObj.masterDeductiblesBlkAllowUpdate = "N";
				variablesObj.giclEvalDeductiblesAllowUpdate = "N";
				variablesObj.masterDepreciationBlkMasterAllowUpdate = "N";
				variablesObj.depreciationDtlAllowUpdate = "N";
				
				
				disableButton("btnApplyDeductibles");
				disableButton("btnApplyDepreciation");
				
				if(obj.evalStatCd == 'PD'){
					enableButton("btnCSL");
					enableButton("btnLOA");
				}else{
					disableButton("btnCSL");
					disableButton("btnLOA");
				}
				disableButton("btnPostReport");
				if(obj.evalStatCd == 'CC'){
					disableButton("btnCancelReport");
					disableButton("btnAdditionalReport");
					disableButton("btnReviseReport");
				}else{
					enableButton("btnCancelReport");
					enableButton("btnAdditionalReport");
					enableButton("btnReviseReport");
				}
				
				if(obj.evalStatCd != 'CC'){
					if(obj.masterFlag == "Y"){
						enableButton("btnAdditionalReport");
						if(obj.cancelFlag == "Y"){
							enableButton("btnReviseReport");
						}else{
							disableButton("btnReviseReport");
						}
					}else{
						disableButton("btnAdditionalReport");
						disableButton("btnReviseReport");
					}
					
					if(obj.cancelFlag == "Y"){
						enableButton("btnCancelReport");
					}else{
						disableButton("btnCancelReport");
					}
				}
				
				if(obj.evalStatCd == "PD" && obj.reportType == "RD"){ // added Feb. 22, 2012
					disableButton("btnCancelReport");
					disableButton("btnAdditionalReport");
					disableButton("btnReviseReport");
				}
			}else{
				toggleEditableOtherDetails(true);
				
				variablesObj.mcEvalAllowUpdate = "Y";
				variablesObj.giclReplaceAllowupdate = "Y";
				variablesObj.giclRepairHdrAllowUpdate = "Y";
				variablesObj.giclEvalVatAllowUpdate = "Y";
				variablesObj.giclRepairLpsDtlAllowUpdate ="Y";
				variablesObj.giclRepairLpsDtlCtrlAllowUpdate ="Y";
				variablesObj.laborBlkAllowUpdate ="Y";
				variablesObj.giclRepairOtherDtlAllowUpdate = "Y";
				variablesObj.masterDeductiblesBlkAllowUpdate = "Y";
				variablesObj.giclEvalDeductiblesAllowUpdate = "Y";
				variablesObj.masterDepreciationBlkMasterAllowUpdate = "Y";
				variablesObj.depreciationDtlAllowUpdate = "Y";
				
				enableButton("btnPostReport");
				enableButton("btnCancelReport");
				
				disableButton("btnAdditionalReport");
				disableButton("btnReviseReport");
				disableButton("btnCSL");
				disableButton("btnLOA");
				
				if(obj.dedFlag == '0'){
					disableButton("btnApplyDeductibles");
					variablesObj.giclEvalDeductiblesAllowUpdate = "N"; //added by: Nica
				}else{
					enableButton("btnApplyDeductibles");
				}
				
				if(obj.depFlag =="0"){
					disableButton("btnApplyDepreciation");
				}//else{
					//enableButton("btnApplyDepreciation");
			//	}
			}
			
			if(obj.inHouAdj =! obj.csoId){
				toggleEditableOtherDetails(false);
				variablesObj.mcEvalAllowUpdate = "N";
				disableButton("btnPostReport");
				disableButton("btnAdditionalReport");
				disableButton("btnReviseReport");
				disableButton("btnCancelReport");
				disableButton("btnDeductibleDetails");
				disableButton("btnApplyDepreciation");
				variablesObj.giclReplaceAllowupdate = "N";
				variablesObj.giclRepairHdrAllowUpdate = "N";
				variablesObj.giclEvalVatAllowUpdate = "N";
				variablesObj.giclRepairLpsDtlAllowUpdate ="N";
				variablesObj.masterDeductiblesBlkAllowUpdate = "N";
				variablesObj.giclEvalDeductiblesAllowUpdate = "N";
				variablesObj.masterDepreciationBlkMasterAllowUpdate = "N";
				variablesObj.depreciationDtlAllowUpdate = "N";
				
			}
		}
		
	}catch(e){
		showErrorMessage("toggleButtons",e);
	}
}