/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.18.2011	mark jm			check if there are pending records in accident grouped items modal page
 */
function hasPendingGroupedItemsChildRecords(){
	try{
		if(getAddedAndModifiedJSONObjects(objGIPIWGroupedItems).length > 0 || getDeletedJSONObjects(objGIPIWGroupedItems).length > 0 ||
				getAddedAndModifiedJSONObjects(objGIPIWItmperlGrouped).length > 0 || getDeletedJSONObjects(objGIPIWItmperlGrouped).length > 0 ||
				getAddedAndModifiedJSONObjects(objGIPIWGrpItemsBeneficiary).length > 0 || getDeletedJSONObjects(objGIPIWGrpItemsBeneficiary).length > 0 ||
				getAddedAndModifiedJSONObjects(objGIPIWItmperlBeneficiary).length > 0 || getDeletedJSONObjects(objGIPIWItmperlBeneficiary).length > 0){
			return true;
		}else{
			return false;
		}
	}catch(e){
		showErrorMessage("hasPendingGroupedItemsChildRecords", e);
	}
}