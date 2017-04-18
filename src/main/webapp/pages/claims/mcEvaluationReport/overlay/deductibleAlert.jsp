<div style="margin-top: 5px; float: left; width: 100%; text-align: center;">
	<img src="${pageContext.request.contextPath}/images/misc/infoBalloon.png" style="margin: 5px 5px 5px 20px; float: left; height: 50px; width: 60px;">
	<label style="float: left; margin-top: 20px;">How many accidents?</label>
</div>
<div style="text-align: center">
	<input type="hidden" id="hidDedCanvas" name="hidDedCanvas" value="${canvas}"/>
	<input type="hidden" id="hidVatExist"  name="hidVatExist" value="${vatExist}"/>
	<input type="text" class="required rightAligned integerNoNegativeUnformatted" id="txtDedNoOfAcc" name="txtDedNoOfAcc" style="width: 200px;" value="" maxlength="5"/>
</div>
<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 10px;" align="center">
	<input type="button" class="button" id="btnOk" 	   name="btnOk" 	value="Ok">
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel">		
</div>

<script type="text/javascript">
	initializeAll();
	$("txtDedNoOfAcc").focus();
	var canvas = $("hidDedCanvas").value;
	
	$("btnCancel").observe("click", function(){
		applyDedOverlay.close();
	});
	
	$("btnOk").observe("click", function(){
		if($("txtDedNoOfAcc").value == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtDedNoOfAcc");
			return false;
		}else{
			if($("hidVatExist").value == "Y"){
				showConfirmBox("Confirmation", "The report to which this detail is under already has Tax/es. "+
						"Updating this record will detele the Tax/es. Do you want to continue?", "Yes", "No", 
						function(){applyDeductiblesForMcEval();}, function(){});
			}else{
				applyDeductiblesForMcEval();				
			}
		}
	});
	
	function applyDeductiblesForMcEval(){
		try{
			new Ajax.Request(contextPath+"/GICLEvalDeductiblesController", {
				asynchronous: true,
				parameters:{
					action: "applyDeductiblesForMcEval",
					evalId    : selectedMcEvalObj.evalId,
					dedNoOfAcc : $("txtDedNoOfAcc").value,
					payeeTypeCd: selectedMcEvalObj.varPayeeTypeCdGiclReplace,
					payeeCd	  : selectedMcEvalObj.varPayeeCdGiclReplace,
					dedBaseAmt: mcMainObj.annTsiAmt,
					lineCd    : mcMainObj.polLineCd,
					sublineCd : mcMainObj.polSublineCd,
					polIssCd  : mcMainObj.polIssCd,
					issueYy   : mcMainObj.polIssueYy,
					polSeqNo  : mcMainObj.polSeqNo,
					renewNo   : mcMainObj.polRenewNo,
					lossDate  : mcMainObj.lossDate,
					itemNo    : mcMainObj.itemNo,
					perilCd   : mcMainObj.perilCd
				},
				onCreate: function(){
					showNotice("Applying Deductibles...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							applyDedOverlay.close();
							showWaitingMessageBox("Deductibles Applied", "I", 
							function(){
								changeTag = 0;
								if(canvas == "DED_DETAILS"){
									hasSaved = "Y";
									genericObjOverlay.close();
									showMcEvalDeductibleDetails();									
								}else{
									refreshMainMcEvalList();
								}
							});	
						}else{
							showMessageBox(response.responseText, "E");							
						}
					}else{
						showMessageBox(response.responseText, "E");							
					}	
				}
			});			
		
		}catch(e){
			showErrorMessage("applyDeductiblesForMcEval", e);	
		}
	}
	
</script>