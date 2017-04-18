/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function callDeleteDeductiblesAlert(){
	try {
		if ($F("deleteTag") == "Y"){
			showConfirmBox("Delete Deductibles", "The "+$F("deductibleLevel")+" has an existing deductible based on % of TSI.  Deleting perils will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesFromPeril, clearItemPerilFields);
		} else if ($("btnAddItemPeril").value != "Update"){
			showConfirmBox("Delete Deductibles", "The "+$F("deductibleLevel")+" has an existing deductible based on % of TSI.  Adding "+$("validateDedCallingElement").getAttribute("fieldInWord")+" will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesFromPeril, clearItemPerilFields);
		} else {
			showConfirmBox("Delete Deductibles", "The "+$F("deductibleLevel")+" has an existing deductible based on % of TSI.  Changing "+$("validateDedCallingElement").getAttribute("fieldInWord")+" will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesFromPeril, clearItemPerilFields);
		}
	} catch(e){
		showErrorMessage("callDeleteDeductiblesAlert", e);
	}
}