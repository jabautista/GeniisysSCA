/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.12.2011	mark jm			copy additional records from other tables related to the item (tableGrid version) 
 * 								Parameter	: itemNo - serve as the primary key
 * 											: nextItemNo - the new primary key
 */
function copyAdditionalInfoTG(itemNo, nextItemNo){
	try{
		var lineCd = getLineCd();
		
		if(lineCd == "MC"){
			copyRelatedAdditionalInfoTG(objMortgagees, itemNo, nextItemNo);
			copyRelatedAdditionalInfoTG(objGIPIWMcAcc, itemNo, nextItemNo);
		}else if(lineCd == "FI"){
			copyRelatedAdditionalInfoTG(objMortgagees, itemNo, nextItemNo);
		}else if(lineCd == "MN"){
			copyRelatedAdditionalInfoTG(objGIPIWCargoCarrier, itemNo, nextItemNo);			
		} else if(lineCd == "CA") {
			copyRelatedAdditionalInfoTG(objGIPIWGroupedItems, itemNo, nextItemNo);
			copyRelatedAdditionalInfoTG(objGIPIWCasualtyPersonnel, itemNo, nextItemNo);
		} else if(lineCd == "AC") {
			copyRelatedAdditionalInfoTG(objBeneficiaries, itemNo, nextItemNo);
			copyRelatedAdditionalInfoTG(objGIPIWGroupedItems, itemNo, nextItemNo);
			copyRelatedAdditionalInfoTG(objGIPIWGrpItemsBeneficiary, itemNo, nextItemNo);
		} 
	} catch(e){
		showErrorMessage("copyAdditionalInfoTG", e);
	}
}