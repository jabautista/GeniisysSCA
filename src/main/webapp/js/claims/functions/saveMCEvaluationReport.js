function saveMCEvaluationReport(){
	try{
		var valid = true;
		if($F("inspectDate") != "" || $F("inspectDate") !=null){
			var inspectDate = makeDate($F("inspectDate"));
			var lossDate = makeDate(mcMainObj.lossDate);
			var dateToday = new Date();
			if(inspectDate > dateToday){
				customShowMessageBox("Inspect date must not be later than current date.", imgMessage.INFO, "inspectDate");
				valid =false;
			}else if(inspectDate < lossDate){
				customShowMessageBox("Inspect date must not be earlier than the loss date.", imgMessage.INFO, "inspectDate");
				valid =false;
			}
		}
		
		if($F("txtPerilCd") == ""){
			showMessageBox("Peril is required.", imgMessage.INFO);
			valid =false;
		}
		
		if($F("txtPerilCd") == ""){
			showMessageBox("Peril is required.", imgMessage.INFO);
			valid =false;
		}
		
		if(valid){
			if($F("editMode") == "Y" && $F("reviseFlag") !="Y"){
				updateMcEvaluationReport();
			}else{
			
				var objParameters = {};
				var newEval = {};
				var extraParam = {};
				newEval.remarks = $F("reviseFlag") =="Y" ? "" : escapeHTML2($F("remarks"));
				newEval.inspectDate = $F("reviseFlag") =="Y" ? "" : $F("inspectDate");
				newEval.dspAdjusterDesc = $F("reviseFlag") =="Y" ? "" : escapeHTML2($F("dspAdjusterDesc"));
				newEval.adjusterId = $F("reviseFlag") =="Y" ? "" :  $F("clmAdjId");
				newEval.inspectPlace = $F("reviseFlag") =="Y" ? "" : escapeHTML2($F("inspectPlace"));
				
				mcMainObj.clmIssCd = $F("txtClmIssCd");
				mcMainObj.clmSublineCd = $F("txtClmSublineCd");
				extraParam.newRepFlag = $F("newRepFlag");
				extraParam.copyDtlFlag = $F("copyDtlFlag");
				extraParam.reviseFlag = $F("reviseFlag");
				
				extraParam.evalMasterId = ($F("copyDtlFlag") == "Y" || $F("reviseFlag") =="Y") ? $F("copiedEvalId"): "" ;
				extraParam.evalStatCd = "";
				extraParam.reportType = "";	
				extraParam.replaceAmt = "";
				extraParam.repairAmt = "";
				
				objParameters.extraParam = prepareJsonAsParameter(extraParam);
				objParameters.mcMainObj = mcMainObj;
				objParameters.newEval = prepareJsonAsParameter(newEval);
				objParameters.varMcMainObj = varMcMainObj;
				
				new Ajax.Request(contextPath + "/GICLMcEvaluationController", {
					parameters:{
						action: "saveMCEvaluationReport",
						parameters: JSON.stringify(objParameters)
					},
					asynchronous: false,
					evalScripts: true,
					onCreate: showNotice("Saving MC Evaluation Report.."),
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response)) {
							//showMessageBox(objCommonMessage.SUCCESS, "S");
							changeTag = 0;
							clearFlags();
							showWaitingMessageBox(objCommonMessage.SUCCESS,"S", refreshMcEvaluationReport);
							//refreshMcEvaluationReport();
							
							/*populateEvalSumFields(null);
							populateOtherDetailsFields(null);
							toggleEditableOtherDetails(false);
							
							if(varInitialSave == "Y"){
								showMcEvaluationReport("itemInfo");
								varInitialSave = "";
							}else{
								varMcMainObj.plateNo = mcMainObj.plateNo; // holds orig values of mcMainObj for masterBlk key commit
								varMcMainObj.itemNo = mcMainObj.itemNo;
								varMcMainObj.perilCd = mcMainObj.perilCd;
								varMcMainObj.tpSw = mcMainObj.tpSw;
								varMcMainObj.payeeClassCd = mcMainObj.payeeClassCd;
								varMcMainObj.payeeNo = mcMainObj.payeeNo;
								mcEvalGrid.refresh();
								refreshMcEvaluationReport();
							}*/
							
						}else{
							showMessageBox(response.responseText, "E");
						}
					}
				});
			}	
		}
	}catch (e) {
		showErrorMessage("saveMCEvaluationReport",e);
	}
}