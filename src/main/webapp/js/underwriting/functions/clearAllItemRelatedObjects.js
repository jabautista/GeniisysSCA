/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	12.15.2011	mark jm			set all item related objects to their default values 
 */
function clearAllItemRelatedObjects(){
	try{
		formMap = {};
		objItemTempStorage = {};
		objGIPIWItem = [];
		objCurrItem = null;
		objGIPIWPerilDiscount = [];
		objDeductibles = [];
		objPolicyDeductibles = [];
		objItemDeductibles = [];
		objItemPerilDeductibles = [];	
		objGIPIWItemPeril = [];
		objGIPIWPolWC = [];		
		objGIPIWGroupedItems = [];
		objGIPIWCasualtyPersonnel = [];
		objGIPIWItmperlGrouped = [];		
		objMortgagees = [];
		objGIPIWMcAcc = [];		
		objGIPIWVesAir = [];
		objGIPIWCargoCarrier = [];		
	
		tbgItemTable = null;
		tbgPolicyDeductible = null;
		tbgItemDeductible = null;
		tbgPerilDeductible = null;
		tbgItemPeril = null;
		tbgMortgagee = null;
		tbgAccessory = null;
		tbgGroupedItems = null;
		tbgCasualtyPersonnel = null;
		tbgCargoCarriers = null;
		tbgBeneficiary = null;
		tbgGrpItemsBeneficiary = null;
		tbgItmperlBeneficiary = null;
		tbgItmperlGrouped = null;
		tbgPopulateBenefits = null;
		tbgUploadEnrollees = null;
		tbgUploadDetails = null;
		tbgErrorLog = null;
		
		//lastAction = null;
	}catch(e){
		showErrorMessage("clearAllItemRelatedObjects", e);
	}
}