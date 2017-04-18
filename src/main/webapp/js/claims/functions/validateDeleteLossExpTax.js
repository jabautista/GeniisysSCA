function validateDeleteLossExpTax(){
	var arrTaxType = []; //Added by: Jerome Bautista 05.25.2015 SR 3641 @lines 2 - 15
	var arrLossExpCd = [];
	var currTaxType = "";
	var index = "";
	
	currTaxType = escapeHTML2($("selTaxType").value);
	
	for(var i=0;i<objGICLLossExpTax.length;i++){
		arrLossExpCd.push(objGICLLossExpTax[i].lossExpCd);
	}
	
	for(var i=0; i<objGICLLossExpTax.length; i++){
		arrTaxType.push(objGICLLossExpTax[i].taxType);
	}
	
	if(objCurrGICLLossExpPayees.payeeType == "L" && nvl(objCurrGICLItemPeril.closeFlag, "AP") != "AP"){
		showMessageBox("You cannot delete this record.", "I");
		return false;
	}else if(objCurrGICLLossExpPayees.payeeType == "E" && nvl(objCurrGICLItemPeril.closeFlag2, "AP") != "AP"){
		showMessageBox("You cannot delete this record.", "I");
		return false;
	}else if(nvl(objCurrGICLClmLossExpense.distSw, "N") == "Y"){
		showMessageBox("You cannot delete this record.", "E");
		return false;
	}else if(hasPendingLossExpTaxRecords()){
		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		return false;
	}else{  //Added by: Jerome Bautista 05.25.2015 SR 3641 @lines 29 - 43
		for(var i=0,j=arrTaxType.length-1;i<j;i++,j--){
			if(arrTaxType[i] == "W" || arrTaxType[j] == "W" || arrTaxType[i] == "O" || arrTaxType[j] == "O"){
				for(var x = 0;x<arrLossExpCd.length;x++){
					index = arrLossExpCd[x];
						if(currTaxType == "I" && index.search("NI") != -1){
							showMessageBox("Cannot delete Input Vat. Remove other maintained Tax/es with computation related to input vat first to proceed with the deletion.","E");
							return false;
						}
					}
			}else{
				return true;
			}
		}
		return true;
	}
}