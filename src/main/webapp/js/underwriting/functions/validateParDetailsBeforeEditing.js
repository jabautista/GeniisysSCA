/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validateParDetailsBeforeEditing(){
	try {		
		if ("Y" == $F("perilGroupExists")){			
			clearItemPerilFields();
			showMessageBox("There are existing grouped item perils and you cannot modify, add or delete perils in current item.", "info");
		} else if ("Y" == objUWParList.discExists && "N" == objFormMiscVariables.miscDeletePerilDiscById){			
			if ($F("deleteTag") == "Y"){
				showMessageBox("Deleting of peril is not allowed because Policy have existing discount. If you want to make any changes Please press the button for removing discounts.", "info");
			} else if ($("btnAddItemPeril").value != "Update"){
				clearItemPerilFields();
				showMessageBox("Adding of new "+$("validateDedCallingElement").getAttribute("fieldInWord")+" is not allowed because Policy have existing discount. If you want to make any changes please delete all discounts.", "info");
			} else if ("compRem" == $F("validateDedCallingElement")){
				clearItemPerilFields();
				showMessageBox("Adding of new "+$("validateDedCallingElement").getAttribute("fieldInWord")+" is not allowed because Policy have existing discount. If you want to make any changes please delete all discounts.", "info");
			} else { //if Update
				clearItemPerilFields();
				showMessageBox("Changes in "+$("validateDedCallingElement").getAttribute("fieldInWord")+"s is not allowed because Policy have existing discount. If you want to make any changes please delete all discounts.", "info");
			}
		} else {			
			if (($F("validateDedCallingElement") == "perilBaseAmt") && ("0" == nvl($F("perilNoOfDays"), "0"))){
				validateBaseAmt();
			} else if (($F("validateDedCallingElement") == "perilNoOfDays") && (0 == parseFloat(nvl($F("perilBaseAmt"), 0)))){
				validateNoOfDays();
			} else {
				//if(itemTablegridSw == "Y"){
					validateDeductibleTG();
				/*}else{
					validateDeductible();
				}*/
				
			}
		}
	} catch (e) {
		showErrorMessage("validateParDetailsBeforeEditing", e);
	}
}