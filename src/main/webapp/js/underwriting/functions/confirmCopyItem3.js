/*	Created by	: mark jm
 * 	Description	: determines which function/procedure of copying is to be used
 */
function confirmCopyItem3(){
	try{			
		var messageText = "";
		var includePeril = "";
		var newItemNo = getNextItemNo("itemTable", "row", "label", 0);
		
		//added condition to not exceed maximum allowable item no. BJGA.12.20.2010
		if (parseInt(newItemNo) > 999999999){
			showMessageBox("New item no. exceeds maximum allowable value. Must be in range 000000001 to 999999999.", imgMessage.ERROR);
			return false;
		}

		if(/*objFormMiscVariables[0].copyPeril*/objFormMiscVariables.miscCopyPeril == "Y"){
			includePeril = "and perils ";
		}else{
			includePeril = "";
		}

		if(/*$("chkIncludeSw").checked*/ $("cgCtrlIncludeSw").checked){
			messageText = "This will create new item (" + newItemNo.toPaddedString(3) + ") with the same item information " + includePeril +
						"(including additional information) as the current item display. Do you want to continue?" ;
			//$("chkIncludeSw").checked = true;
			$("cgCtrlIncludeSw").checked = true;
		}else{
			messageText = "This will create new item (" + newItemNo.toPaddedString(3) + ") with the same item information " + includePeril +
						"(excluding additional information) as the current item display. Do you want to continue?" ;
			//$("chkIncludeSw").checked = false;
			$("cgCtrlIncludeSw").checked = false;
		}

		showConfirmBox("Copy Item", messageText, "Yes", "No", copyItem, stopProcess);
	}catch(e){
		showErrorMessage("confirmCopyItem3", e);
	}
}