function enableDisableLossExpDtlForm(enableSw){
	$("hrefLoss").stopObserving("click");
	if(enableSw == "enable"){
		//$("txtBaseAmt").readOnly = false;
		$("txtUnits").readOnly = false;
		$("chkOriginalSw").enable();
		$("chkWithTax").enable();
		enableButton("btnAddLossExpDtl");
		$("btnAddLossExpDtl").value == "Add" ? $("hrefLoss").show() : $("hrefLoss").hide();
		
		$("hrefLoss").observe("click", function(){
			if(objCurrGICLItemPeril == null){
				showMessageBox("Please select an item first.", "I");
			}else if(objCurrGICLLossExpPayees == null){
				showMessageBox("Please select a payee first.", "I");
			}else if(objCurrGICLClmLossExpense == null){
				showMessageBox("Please select a history record first.", "I");
			}else if(hasPendingLossExpDtlRecords()){ //Added by Kenneth 05.26.2015 SR 3625
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				populateLossExpDtlForm(null);
				return false;
			}else{
				var notIn = createCompletedNotInParam(giclLossExpDtlTableGrid, "lossExpCd");
				getGiisLossExpLOV(objCurrGICLItemPeril, objCurrGICLLossExpPayees, objCurrGICLClmLossExpense, notIn);
				if(objCLMGlobal.menuLineCd == "AC" && nvl(objCurrGICLItemPeril.noOfDays, 0) > 0){
					if($F("hidenableLeBaseAmt") == "Y"){
						$("txtBaseAmt").readOnly = false;
					}else{
						$("txtBaseAmt").readOnly = true;
					}
				}else{
					$("txtBaseAmt").readOnly = false;
				}
			}
		});
	}else{
		$("txtBaseAmt").readOnly = true;
		$("txtUnits").readOnly = true;
		$("chkOriginalSw").disable();
		$("chkWithTax").disable();
		disableButton("btnAddLossExpDtl");
		disableButton("btnDeleteLossExpDtl");
		$("hrefLoss").hide();
	}
}