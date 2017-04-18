/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	xx.xx.xxxx	mark jm			created function to check if there are pending records
 * 	09.01.2011	mark jm			added condition for motorcar (MC)
 * 	09.20.2011	mark jm			added condition for casualty (CA)
 * 								added condition for marine cargo (MN)
 * 	11.08.2011	mark jm			added condition for accident
 */
function hasPendingChildRecords(){
	try{
		var lineCd = getLineCd(null);
		var hasPendingRecords = false;
		
		var hasPendingDeductibles = false;
		var hasPendingPerils = false;
		var hasPendingMortgagees = false;
		var hasPendingAccessories = false;
		var hasPendingGroupedItems = false;
		var hasPendingCasPersonnels = false;
		var hasPendingVesAir = false;
		var hasPendingVesAccumulation = false;
		var hasPendingCargoCarriers = false;
		var hasPendingBeneficiaries = false;
		
		hasPendingDeductibles = getAddedAndModifiedJSONObjects(objDeductibles).length > 0 || getDeletedJSONObjects(objDeductibles).length > 0 ? true : false;
		hasPendingPerils = getAddedAndModifiedJSONObjects(objGIPIWItemPeril).length > 0 || getDeletedJSONObjects(objGIPIWItemPeril).length > 0 ? true : false;
		
		if(hasPendingDeductibles || hasPendingPerils){
			hasPendingRecords = true;
		}
		
		if(lineCd == "FI"){
			hasPendingMortgagees = getAddedAndModifiedJSONObjects(objMortgagees).length > 0 || getDeletedJSONObjects(objMortgagees).length > 0 ? true : false;
			
			if(hasPendingRecords || hasPendingMortgagees){
				hasPendingRecords = true;
			}
		}else if(lineCd == "MC"){
			hasPendingMortgagees = getAddedAndModifiedJSONObjects(objMortgagees).length > 0 || getDeletedJSONObjects(objMortgagees).length > 0 ? true : false;
			hasPendingAccessories = getAddedAndModifiedJSONObjects(objGIPIWMcAcc).length > 0 || getDeletedJSONObjects(objGIPIWMcAcc).length > 0 ? true : false;
			
			if(hasPendingRecords || hasPendingMortgagees || hasPendingAccessories){
				hasPendingRecords = true;
			}
		}else if(lineCd == "CA"){
			hasPendingGroupedItems = getAddedAndModifiedJSONObjects(objGIPIWGroupedItems).length > 0 || getDeletedJSONObjects(objGIPIWGroupedItems).length > 0 ? true : false;
			hasPendingCasPersonnels = getAddedAndModifiedJSONObjects(objGIPIWCasualtyPersonnel).length > 0 || getDeletedJSONObjects(objGIPIWCasualtyPersonnel).length > 0 ? true : false;
			
			if(hasPendingRecords || hasPendingGroupedItems || hasPendingCasPersonnels){
				hasPendingRecords = true;
			}
		}else if(lineCd == "MN"){
			hasPendingVesAir = getAddedAndModifiedJSONObjects(objGIPIWVesAir).length > 0 || getDeletedJSONObjects(objGIPIWVesAir).length > 0 ? true : false;
			hasPendingVesAccumulation = getAddedAndModifiedJSONObjects(objGIPIWVesAccumulation).length > 0 || getDeletedJSONObjects(objGIPIWVesAccumulation).length > 0 ? true : false;
			hasPendingCargoCarriers = getAddedAndModifiedJSONObjects(objGIPIWCargoCarrier).length > 0 || getDeletedJSONObjects(objGIPIWCargoCarrier).length > 0 ? true : false;
			
			if(hasPendingRecords || hasPendingVesAir || hasPendingVesAccumulation || hasPendingCargoCarriers){
				hasPendingRecords = true;
			}
		}else if(lineCd == "AC"){
			hasPendingBeneficiaries = getAddedAndModifiedJSONObjects(objBeneficiaries).length > 0 || getDeletedJSONObjects(objBeneficiaries).length > 0 ? true : false;
			
			if(hasPendingRecords || hasPendingBeneficiaries){
				hasPendingRecords = true;
			}
		}
		
		return hasPendingRecords;
	}catch(e){
		showErrorMessage("hasPendingChildRecords", e);
	}
}