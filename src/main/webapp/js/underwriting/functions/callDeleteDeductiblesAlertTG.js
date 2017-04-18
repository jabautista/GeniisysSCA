/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.16.2011	mark jm			table grid version
 */
function callDeleteDeductiblesAlertTG(){
	try {
		if ($F("deleteTag") == "Y"){
			showConfirmBox("Delete Deductibles", "The "+$F("deductibleLevel")+" has an existing deductible based on % of TSI.  Deleting perils will delete the existing deductible. Continue?", "Ok", "Cancel", function(){deleteDeductiblesTableGridFromPeril($F("deleteTag"));}, function(){setItemPerilForm(null);$("deleteTag").value = "N";});
		} else if ($("btnAddItemPeril").value != "Update"){
			showConfirmBox("Delete Deductibles", "The "+$F("deductibleLevel")+" has an existing deductible based on % of TSI.  Adding "+$("validateDedCallingElement").getAttribute("fieldInWord")+" will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesTableGridFromPeril, function(){setItemPerilForm(null);});
		} else {
			showConfirmBox("Delete Deductibles", "The "+$F("deductibleLevel")+" has an existing deductible based on % of TSI.  Changing "+$("validateDedCallingElement").getAttribute("fieldInWord")+" will delete the existing deductible. Continue?", "Ok", "Cancel", deleteDeductiblesTableGridFromPeril, function(){setItemPerilForm(null);});
		}
	} catch(e){
		showErrorMessage("callDeleteDeductiblesAlertTG", e);
	}
}