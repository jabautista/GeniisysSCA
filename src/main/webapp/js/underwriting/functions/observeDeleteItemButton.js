/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	11.17.2011	mark jm			set observer for delete item button (table grid)
 */
function observeDeleteItemButton(){
	try{
		function deleteItem(itemNo){
			//belle 05.22.2012 
			if (objUWParList.binderExist == "Y") {
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}

			if(objFormMiscVariables.miscDeletePerilDiscById == "Y" && objFormMiscVariables.miscDeleteItemDiscById == "N" && objFormMiscVariables.miscDeletePolbasDiscById == "N"){
				parItemDeleteDiscount(false);
				
				// mark jm 11.22.2011 set the recordStatus of the item/peril to be delete to null due to delete discount procedure
				var objItemArrFiltered = objGIPIWItem.filter(function(o){	return o.itemNo == itemNo; });
				
				for(var i=0, length=objItemArrFiltered.length; i < length; i++){					
					objItemArrFiltered[i].recordStatus = null;					
				}
				
				var objItemPerilArrFiltered = objGIPIWItemPeril.filter(function(o){	return o.itemNo == itemNo; });
				
				for(var i=0, length=objItemPerilArrFiltered.length; i < length; i++){
					objItemPerilArrFiltered[i].recordStatus = null;
				}				
			}
			
			//added by gab 09.29.2016 SR 5665
			for(var i=0, length=objGIPIWItemPeril.length; i < length; i++){
				if(itemNo == objGIPIWItemPeril[i].itemNo){
					objGIPIWItemPeril[i].recordStatus = -1;
				}
			}
			
			objFormMiscVariables.miscNbtInvoiceSw = "Y";
			deleteParItem2();

			if(checkDeductibleType(objDeductibles, 1, "T") && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
				objFormMiscVariables.miscDeletePolicyDeductibles = "Y";
			}
			
			changeTag = 1; // temp solution for PA ITEM not Triggering changetag went deleting an item -- irwin 8.29.2012
			objUWGlobal.parItemPerilChangeTag = 1; // Apollo Cruz 09.11.2014
		}

		function delRec(itemNo){
			if(objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N"){
				showConfirmBox("Discount", "Deleting an item will result to the deletion of all discounts. Do you want to continue ?",
						"Continue", "Cancel", function(){
					objFormMiscVariables.miscDeletePerilDiscById = "Y";
					deleteItem(itemNo);
				}, stopProcess);
			}else{
				deleteItem(itemNo);
			}
		}	
		
		$("btnDeleteItem").observe("click", function(){
			if(objFormParameters.paramIsPack == "Y"){
				showConfirmBox("Confirmation", "You are not allowed to delete items here. Delete this item in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
				return false;			
			}
			var itemNo = $F("itemNo");

			var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 1, "T");		

			if(itemTsiDeductibleExist && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
				showConfirmBox("Deductibles", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. Continue?",
						"Yes", "No", function(){				
					delRec(itemNo);
				}, stopProcess);
			}else{
				delRec(itemNo);
			}
		});
		
	}catch(e){
		showErrorMessage("observeDeleteItemButton", e);
	}
}