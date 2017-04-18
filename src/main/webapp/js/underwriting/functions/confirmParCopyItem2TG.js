/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.11.2011	mark jm			second validation in copying an item w/ or w/out perils
 */
function confirmParCopyItem2TG(){
	try{
		//objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
		
		if(/*objFormVariables.varDiscExist == "Y"*/ objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
			showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue?",
					"Continue", "Cancel", function() {
				deleteDiscounts();
				preConfirmParCopyItem3TG();
			}, stopProcess);
		}else{
			confirmParCopyItem3TG();
		}
	}catch(e){
		showErrorMessage("confirmParCopyItem2TG", e);		
	}
}