function confirmParCopyItem3(){
	try{
		var messageText = "";
		var includePeril = "";
		var newItemNo = getNextItemNoFromObj();//getNextItemNo("itemTable", "row", "label", 0);
		
		if(parseInt(newItemNo) > 999999999){
			showMessageBox("New item no. exceeds maximum allowable value. Must be in range 000000001 to 999999999.", imgMessage.ERROR);
			stopProcess();
		}	
		
		includePeril = objFormMiscVariables.miscCopyPeril == "Y" ? "and perils " : "";
		
		if($("cgCtrlIncludeSw").checked){
			messageText = "This will create new item (" + newItemNo.toPaddedString(3) + ") with the same item information " + includePeril +
						"(including additional information) as the current item display. Do you want to continue?" ;
		}else{
			messageText = "This will create new item (" + newItemNo.toPaddedString(3) + ") with the same item information " + includePeril +
						"(excluding additional information) as the current item display. Do you want to continue?" ;
		}
		
		showConfirmBox("Copy Item", messageText, "Yes", "No", parCopyItem, stopProcess);
	}catch(e){
		showErrorMessage("confirmParCopyItem3", e);
		//showMessageBox("confirmParCopyItem3 : " + e.message);
	}
}