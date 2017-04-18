function confirmParCopyItem2(){
	try{
		//objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
		
		if(/*objFormVariables.varDiscExist == "Y"*/ objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
			showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue?",
					"Continue", "Cancel", function() {
				deleteDiscounts();
				preConfirmParCopyItem3();
			}, stopProcess);
		}else{
			confirmParCopyItem3();
		}
	}catch(e){
		showErrorMessage("confirmParCopyItem2", e);
		//showMessageBox("confirmParCopyItem2 : " + e.message);
	}
}