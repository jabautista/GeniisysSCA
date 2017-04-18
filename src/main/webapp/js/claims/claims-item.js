var objCLMItem 						= {};		// claims item object
objCLMItem.selected 				= {};		// current item record
objCLMItem.selectedPeril 			= {};		// current peril record
objCLMItem.newItem					= [];		// new item record
objCLMItem.newPeril					= [];		// new peril record
objCLMItem.newPersonnel 			= [];		// new personnel record
objCLMItem.selItemIndex				= null;		// current item index
objCLMItem.selPerilIndex			= null;		// current peril index
objCLMItem.objItemTableGrid			= {};		// item table grid
objCLMItem.objPerilTableGrid		= {};		// peril table grid
objCLMItem.objPerilStatusTableGrid	= {};		// peril status table grid
objCLMItem.objMortgageeTableGrid	= {};		// mortgagee table grid
objCLMItem.objGiclItemPeril			= {}; 		// peril rows
objCLMItem.objGiclItemPerilStatus	= {}; 		// peril status rows
objCLMItem.objGiclMortgagee			= {}; 		// mortgagee rows
objCLMItem.overrider				= false; 	// overrider allowed
objCLMItem.itemLovSw				= false; 	// item LOV
objCLMItem.grpItemLovSw				= false; 	// group item LOV 
objCLMItem.perilCd					= null;		// current peril code
objCLMItem.lossCatCd				= null;		// current loss category code
objCLMItem.deletePerilSw			= false;	// delete peril switch
objCLMItem.objItemBenTBG			= {};       // beneficiary table grid
objCLMItem.newBeneficiary			= [];		// new beneficiary record
objCLMItem.selBenIndex				= null;		// current beneficiary index
objCLMItem.objAvailmentsTBG			= {};       // availments table grid
objCLMItem.benCount					= null;		// beneficiary count

objCLMItem.objGiclFireDtl			= {};		// fire item rows
objCLMItem.objGiclMotorCarDtl 		= {};       // motorCar item rows
objCLMItem.objGiclCargoDtl 			= {};       // Marine Cargo item rows
objCLMItem.objGiclAviationDtl 		= {};       // Aviation item rows
objCLMItem.objGiclAccidentDtl 		= {};       // Accident item rows

objCLMItem.objCALossLocation1       = "";       // Added by J. Diago 10.17.2013 Holds Claim Loss Location for Line CA.
objCLMItem.objCALossLocation2       = "";       // Added by J. Diago 10.17.2013
objCLMItem.objCALossLocation3       = "";       // Added by J. Diago 10.17.2013
objCLMItem.ora2010SwCA              = "N";
objCLMItem.vLocLossCA               = "";
 
var itemGrid = new Object();
var perilGrid = new Object();
var perilStatusGrid = new Object();
var mortgageeGrid = new Object();
var perilModel = {};
var perilStatusModel = {};
var mortgageeModel = {};
var beneficiaryGrid = new Object();
var beneficiaryModel ={};
var availmentsGrid	= new Object();
var availmentsModel = {};

var claimItemModuleId = new Object();
claimItemModuleId.MOTORCAR  	= "GICLS014";
claimItemModuleId.FIRE 			= "GICLS015";
claimItemModuleId.CASUALTY 		= "GICLS016";
claimItemModuleId.MARINECARGO   = "GICLS019";
claimItemModuleId.AVIATION   	= "GICLS020";
claimItemModuleId.ENGINEERING	= "GICLS021";
claimItemModuleId.MARINEHULL    = "GICLS022"; // Rey 11-28-2011
claimItemModuleId.ACCIDENT		= "GICLS017"; 

/**
 * Add new Marine Cargo item record
 * 
 * @author Irwin 10.4.11
 */
/*function addClmMarineCargoItem(){
	try{
		/*
		 * if($F("btnAddItem") == "Add"){ objCLMItem.newItem[0].drvrName =
		 * escapeHTML2($F("txtDrvrName")); objCLMItem.newItem[0].drvrOccCd =
		 * $F("txtDrvrOccCd"); objCLMItem.newItem[0].drvrOccDesc =
		 * escapeHTML2($F("txtDrvrOccDesc")); objCLMItem.newItem[0].drvrAdd =
		 * escapeHTML2($F("txtDrvrAdd")); objCLMItem.newItem[0].relation =
		 * escapeHTML2($F("txtRelation")); objCLMItem.newItem[0].drvngExp =
		 * $F("txtDrvngExp"); objCLMItem.newItem[0].drvrAge = $F("txtDrvrAge");
		 * objCLMItem.newItem[0].drvrSex = $F("txtDrvrSex");
		 * objCLMItem.newItem[0].nationalityCd = $F("txtNationalityCd");
		 * objCLMItem.newItem[0].nationalityDesc = $F("txtNationalityDesc");
		 * }else{ var gIndex = objCLMItem.selItemIndex ;
		 * itemGrid.setValueAt(escapeHTML2($F("txtDrvrName")),itemGrid.getColumnIndex("drvrName"),gIndex,true);
		 * itemGrid.setValueAt($F("txtDrvrOccCd"),itemGrid.getColumnIndex("drvrOccCd"),gIndex,true);
		 * itemGrid.setValueAt(escapeHTML2($F("txtDrvrOccDesc")),itemGrid.getColumnIndex("drvrOccDesc"),gIndex,true);
		 * itemGrid.setValueAt(escapeHTML2($F("txtDrvrAdd")),itemGrid.getColumnIndex("drvrAdd"),gIndex,true);
		 * itemGrid.setValueAt(escapeHTML2($F("txtRelation")),itemGrid.getColumnIndex("relation"),gIndex,true);
		 * itemGrid.setValueAt($F("txtDrvngExp"),itemGrid.getColumnIndex("drvngExp"),gIndex,true);
		 * itemGrid.setValueAt($F("txtDrvrAge"),itemGrid.getColumnIndex("drvrAge"),gIndex,true);
		 * itemGrid.setValueAt(escapeHTML2($F("txtDrvrSex")),itemGrid.getColumnIndex("drvrSex"),gIndex,true);
		 * itemGrid.setValueAt(escapeHTML2($F("txtNationalityCd")),itemGrid.getColumnIndex("nationalityCd"),gIndex,true);
		 * itemGrid.setValueAt(escapeHTML2($F("txtNationalityDesc")),itemGrid.getColumnIndex("nationalityDesc"),gIndex,true); }
		 
		if($F("btnAddItem") == "Add"){
			objCLMItem.newItem[0].drvrName = escapeHTML2($F("txtDrvrName"));
			objCLMItem.newItem[0].drvrOccCd = $F("txtDrvrOccCd");
			objCLMItem.newItem[0].drvrOccDesc = escapeHTML2($F("txtDrvrOccDesc"));
			objCLMItem.newItem[0].drvrAdd = escapeHTML2($F("txtDrvrAdd"));
			objCLMItem.newItem[0].relation = escapeHTML2($F("txtRelation"));
			objCLMItem.newItem[0].drvngExp = $F("txtDrvngExp");
			objCLMItem.newItem[0].drvrAge = $F("txtDrvrAge");
			objCLMItem.newItem[0].drvrSex = $F("txtDrvrSex");
			objCLMItem.newItem[0].nationalityCd = $F("txtNationalityCd");
			objCLMItem.newItem[0].nationalityDesc = $F("txtNationalityDesc");
		}else{
			var gIndex = objCLMItem.selItemIndex ;
			itemGrid.setValueAt(escapeHTML2($F("txtDrvrName")),itemGrid.getColumnIndex("drvrName"),gIndex,true);
			itemGrid.setValueAt($F("txtDrvrOccCd"),itemGrid.getColumnIndex("drvrOccCd"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDrvrOccDesc")),itemGrid.getColumnIndex("drvrOccDesc"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDrvrAdd")),itemGrid.getColumnIndex("drvrAdd"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtRelation")),itemGrid.getColumnIndex("relation"),gIndex,true);
			itemGrid.setValueAt($F("txtDrvngExp"),itemGrid.getColumnIndex("drvngExp"),gIndex,true);
			itemGrid.setValueAt($F("txtDrvrAge"),itemGrid.getColumnIndex("drvrAge"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDrvrSex")),itemGrid.getColumnIndex("drvrSex"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtNationalityCd")),itemGrid.getColumnIndex("nationalityCd"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtNationalityDesc")),itemGrid.getColumnIndex("nationalityDesc"),gIndex,true);
		}
		addClmItem();
	}catch(e){
		showErrorMessage("addClmMarineCargoItem",e);
	}
}*/

var tpSelectedIndex = null; // mcTpDtl table grid index