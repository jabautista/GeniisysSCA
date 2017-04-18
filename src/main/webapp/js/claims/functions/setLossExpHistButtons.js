function setLossExpHistButtons(giclClmLossExp){
	if(giclClmLossExp == null || giclClmLossExp == undefined){
		disableButton("btnDistDate");
		disableButton("btnDistribute");
		disableButton("btnNegate");
		disableButton("btnViewHistory");
		disableButton("btnLossTax");
		disableButton("btnBillInfo");
		disableButton("btnCancelHistory");
		disableButton("btnClearHist");
		$("radioUW").disable();
		$("radioReserve").disable();
		$("btnDistribute").value = "Distribute";
		return false;
	}
	
	if(nvl(giclClmLossExp.distSw, "N") == "Y"){
		if(nvl(giclClmLossExp.cancelSw, "N") == "N"){
		   disableButton("btnDistribute");
		   disableButton("btnDistDate");
		   enableButton("btnNegate");
		   checkRedistribute(giclClmLossExp, false);
		}else{
		   enableButton("btnDistribute");
		   enableButton("btnDistDate");
		   disableButton("btnNegate");
		   checkRedistribute(giclClmLossExp, true);
		}
	}else{
		disableButton("btnNegate");
		if(nvl(objCurrGICLClmLossExpense.withLossExpDtl, "N") == "Y"){
			enableButton("btnDistribute");
			enableButton("btnDistDate");
			checkRedistribute(giclClmLossExp, true);
		}else{
			disableButton("btnDistribute");
			disableButton("btnDistDate");
			checkRedistribute(giclClmLossExp, false);
		}	
	}
	
	if(nvl(objCurrGICLLossExpPayees.existClmLossExp, "N") == "Y"){
		if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
			enableButton("btnLossTax");
			enableButton("btnBillInfo");
			disableButton("btnCancelHistory");
		}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
			enableButton("btnLossTax");
			enableButton("btnBillInfo");
			disableButton("btnCancelHistory");
		}else{
			if(nvl(giclClmLossExp.distSw, "N") == "Y"){
				enableButton("btnLossTax");
				enableButton("btnBillInfo");
				disableButton("btnCancelHistory");
			}else{
				enableButton("btnBillInfo");
				enableButton("btnCancelHistory");
				disableButton("btnLossTax");
				if(nvl(giclClmLossExp.cancelSw, "N") == "Y"){
					disableButton("btnCancelHistory");
				}
				if(nvl(giclClmLossExp.withLossExpDtl, "N") == "Y"){
					enableButton("btnLossTax");
				}
			}
		}
	}
	enableButton("btnClearHist");
	enableButton("btnViewHistory");
}