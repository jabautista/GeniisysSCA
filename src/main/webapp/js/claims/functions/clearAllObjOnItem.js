function clearAllObjOnItem(){
	try{
		objCLMItem.selected 				= {};		// current item record
		objCLMItem.selectedPeril 			= {};		// current peril record
		objCLMItem.newItem					= [];		// new item record
		objCLMItem.newPeril					= [];		// new peril record
		objCLMItem.newPersonnel 			= [];		// new personnel record
		objCLMItem.selItemIndex				= null;		// current item index
		objCLMItem.selPerilIndex			= null;		// current peril index
		objCLMItem.objItemTableGrid			= {};		// item table grid
		objCLMItem.objPerilTableGrid		= {};		// peril table grid
		objCLMItem.objPerilStatusTableGrid	= {};		// peril status table
														// grid
		objCLMItem.objMortgageeTableGrid	= {};		// mortgagee table grid
		objCLMItem.objGiclItemPeril			= {}; 		// peril rows
		objCLMItem.objGiclItemPerilStatus	= {}; 		// peril status rows
		objCLMItem.objGiclMortgagee			= {}; 		// mortgagee rows
		objCLMItem.overrider				= false; 	// overrider allowed
		objCLMItem.itemLovSw				= false;	// item LOV
		objCLMItem.grpItemLovSw				= false;	// group item LOV
		objCLMItem.perilCd					= null;		// current peril code
		objCLMItem.lossCatCd				= null;		// current loss category
														// code
		objCLMItem.deletePerilSw			= false;	// delete peril switch
		
		objCLMItem.objGiclFireDtl			= {};		// fire item rows
		objCLMItem.objGiclMotorCarDtl 		= {};       // motorCar item rows
		objCLMItem.objGiclCargoDtl 			= {};       //Marine Cargo item rows
		objCLMItem.objGiclAviationDtl 		= {}; 
		
		objCLMItem.objItemBenTBG			= {};       
		objCLMItem.newBeneficiary			= [];		
		objCLMItem.selBenIndex				= null;
		
		itemGrid = new Object();
		perilGrid = new Object();
		perilStatusGrid = new Object();
		mortgageeGrid = new Object();
		personnelGrid = new Object();
		
		perilModel = {};
		perilStatusModel = {};
		mortgageeModel = {};
		
		beneficiaryGrid = new Object(); 
		beneficiaryModel = {};
		
		clearClmItemForm();
	}catch(e){
		showErrorMessage("clearAllObjOnItem", e);
	}
}