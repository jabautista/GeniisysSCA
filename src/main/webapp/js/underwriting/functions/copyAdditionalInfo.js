/*	Created by	: mark jm 10.18.2010
 * 	Description	: copy additional records from other tables related to the item
 * 	Parameter	: itemNo - serve as the primary key
 * 				: nextItemNo - the new primary key 
 */
function copyAdditionalInfo(itemNo, nextItemNo){
	try{
		var lineCd = getLineCd();
		
		if(lineCd == "MC"){
			copyRelatedAdditionalInfo(objMortgagees, itemNo, nextItemNo, "mortgageeListing",
					"rowMortg", "mortgCd", "mortgagees");
			copyRelatedAdditionalInfo(objGIPIWMcAcc, itemNo, nextItemNo, "accListing",
					"rowAcc", "accessoryCd", "accessories");
		}else if(lineCd == "FI"){
			copyRelatedAdditionalInfo(objMortgagees, itemNo, nextItemNo, "mortgageeListing",
					"rowMortg", "mortgCd", "mortgagees");
		}else if(lineCd == "MN"){
			copyRelatedAdditionalInfo(objGIPIWCargoCarrier, itemNo, nextItemNo, "cargoCarrierListing",
					"rowCargoCarrier", "vesselCd", "carriers");
			//copyRelatedAdditionalInfo(objCargoCarriers, itemNo, nextItemNo, "carrierListing", 
			//		"rowCarrier", "vesselCd", "carriers");
		} else if(lineCd == "CA") {// andrew - 11.11.2010 - changed the condition
			copyRelatedAdditionalInfo(objGIPIWGroupedItems, itemNo, nextItemNo, "groupedItemListing",
					"rowGroupedItem", "groupedItemNo", "groupedItems");
			copyRelatedAdditionalInfo(objGIPIWCasualtyPersonnel, itemNo, nextItemNo, "casualtyPersonnelListing",
					"rowCasualtyPersonnel", "personnelNo", "casualtyPersonnel");
		} else if(lineCd == "AH") {
			copyRelatedAdditionalInfo(objBeneficiaries, itemNo, nextItemNo, "beneficiaryListing",
					"rowBen", "beneficiaryNo", "beneficiaryInformation");
		} 
	} catch(e){
		showErrorMessage("copyAdditionalInfo", e);
		//showMessageBox("copyAdditionalInfo : " + e.message);
	}
}