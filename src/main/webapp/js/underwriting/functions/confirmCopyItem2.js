/*	Created by	: mark jm
 * 	Description	: check if record has discounts
 */
function confirmCopyItem2(){
	try{			
		objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
		//objFormMiscVariables[0].miscDeletePolicyDeductibles = "Y";

		if(/*objCurrEndtItem.recFlag*/ objCurrItem.recFlag != "A"){
			showMessageBox("Copy Item facility is only available for additional item.", imgMessage.INFO);
			stopProcess();
		}else if(/*objFormVariables[0].varDiscExist*/ objFormVariables.varDiscExist == "Y"){
			showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue?",
					"Yes", "No", preConfirmCopyItem3, stopProcess);
		}else{				
			confirmCopyItem3();
		}			
	}catch(e){
		showErrorMessage("confirmCopyItem2", e);
	}	
}