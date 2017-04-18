/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.10.2011	mark jm			reset the variables used in item module
 * 	09.02.2011	mark jm			added objGIPIWMcAcc in resetting
 * 	09.20.2011	mark jm			added objGIPIWGroupedItems, objGIPIWCasualtyPersonnel, 
 * 								objGIPIWVesAir, and objGIPIWVesAccumulation in resetting
 */
function resetItemObjects(){
	try{		
		objGIPIWItem 				= objItemTempStorage.objGIPIWItem.slice(0);
		objDeductibles 				= objItemTempStorage.objGIPIWDeductibles.slice(0);
		objGIPIWItemPeril 			= objItemTempStorage.objGIPIWItemPeril.slice(0);
		
		switch(getLineCd()){
			case "FI"	: objMortgagees = objItemTempStorage.objGIPIWMortgagee.slice(0); break;
			case "MC"	: objMortgagees = objItemTempStorage.objGIPIWMortgagee.slice(0); 
						  objGIPIWMcAcc	= objItemTempStorage.objGIPIWMcAcc.slice(0); break;
			case "CA"	: objGIPIWGroupedItems = objItemTempStorage.objGIPIWGroupedItems.slice(0);
						  objGIPIWCasualtyPersonnel	= objItemTempStorage.objGIPIWCasualtyPersonnel.slice(0); break;
			case "MN"	: objGIPIWVesAir = objItemTempStorage.objGIPIWVesAir.slice(0);
						  objGIPIWVesAccumulation = objItemTempStorage.objGIPIWVesAccumulation.slice(0); break;
		}		
	}catch(e){
		showErrorMessage("resetItemObjects", e);
	}
}