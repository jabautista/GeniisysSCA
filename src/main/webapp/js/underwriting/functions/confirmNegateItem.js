function confirmNegateItem(){
	objFormMiscVariables.miscNbtInvoiceSw = "Y";
	if (objUWParList.binderExist == "Y" && objFormMiscVariables.miscNbtInvoiceSw == "Y"){
		showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);		
		objFormMiscVariables.miscNbtInvoiceSw = "N";
		return false;
	}
	
	if ($("endtPerilTable") == null) { // andrew - 11.24.2010 - added this 'if' block to load the endt item peril if not yet loaded
		showEndtPerilInfoPage();
	}
	
	if(objCurrItem.recFlag == "A"){ //	if(objCurrEndtItem.recFlag == "A"){
		showMessageBox("Item Negation is not available for additional item.", imgMessage.INFO);
		stopProcess();
	}else{
		var terminateProcess = false;
		
		for(var i=0, length=objPolbasics.length; i < length; i++){
			var polEffDate = new Date(objPolbasics[i].effDate);
			var parEffDate = new Date(objParPolbas.effDate); 
			if((polEffDate <=  parEffDate) &&
					(new Date(nvl(objPolbasics[i].endtExpiryDate, objPolbasics[i].expiryDate) >= parEffDate))){
				if(objPolbasics[i].annTsiAmt == 0 && objPolbasics[i].annPremAmt == 0){
					showMessageBox("This item had already been negated or zero out on previous endorsement.", imgMessage.INFO);
					terminateProcess = true;
					break;
				}
			}
			delete polEffDate, parEffDate;
		}

		if(terminateProcess){
			return false;
		}

		if(nvl(objFormVariables.varDiscExist, "N") == "Y"){				
			showConfirmBox("Discount", "Negating an item will cause the deletion of all discounts. Do you want to continue ?",
					"Continue", "Cancel", 
					function(){
						objFormVariables.varDiscExist = "N";
						confirmNegateItem2();
			}, stopProcess);
		}else{
			confirmNegateItem2();
		}
	}
}