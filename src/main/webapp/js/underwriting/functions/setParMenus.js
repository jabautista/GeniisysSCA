/*
 * Created By	: Andrew
 * Date			: September 29, 2010
 * Description	: Enables or disables the menus depending on the given condition
 * Parameters	: lineCd 	- line code of par
 * 				  sublineCd - subline code of par
 * 				  issCd   	- issue code of par
 * 				  opFlag    - 
 * 				  parStatus - status of par
 */
function setParMenus(parStatus, lineCd, sublineCd, opFlag, issCd){
	try {
		setParMenusByStatus(parStatus);
		enableMenu("basic");
		checkUserModule("GIPIS017") && (objUWGlobal.lineCd == objLineCds.SU || objUWGlobal.menuLineCd == "SU") ? enableMenu("bondBasicInfo") : disableMenu("bondBasicInfo");
		parStatus > 2 && checkUserModule("GIPIS045") && (objUWGlobal.lineCd == objLineCds.EN || objUWGlobal.menuLineCd == "EN") ? enableMenu("additionalEngineeringInfo") : disableMenu("additionalEngineeringInfo");			
		issCd == "RI" ? enableMenu("initialAcceptance") : disableMenu("initialAcceptance");
		checkUserModule("GIPIS018") && (objUWGlobal.lineCd == objLineCds.SU || objUWGlobal.menuLineCd == "SU") ? enableMenu("collateralTransaction") : disableMenu("collateralTransaction");
		parStatus > 2 && checkUserModule("GIPIS007") && (objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == "MN") && parStatus >= 3 && sublineCd != "" && opFlag != "Y" ? enableMenu("carrierInfo") : disableMenu("carrierInfo");
		parStatus > 2 && checkUserModule("GIPIS089") && (objUWGlobal.lineCd == objLineCds.CA || objUWGlobal.menuLineCd == "CA") && sublineCd == "BBI" ? enableMenu("bankCollection") : disableMenu("bankCollection");
		disableMenu("lineSublineCoverages"); //wala pang condition sa pag-disable o pag-enable;
		//disableMenu("coInsurance"); //added by Nok 02.16.2011
		
		disableMenu("cargoLimitsOfLiability");
		if(parStatus > 2 &&  
				//marco - 09.18.2013 - separated modules for par and endt
				checkUserModule((nvl(objUWParList.parType, $F("globalParType")) == "P" || nvl(objUWGlobal.parType, $F("globalParType")) == "P") ? "GIPIS005" : "GIPIS078")
				&& (objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == "MN") && sublineCd != "" && opFlag == "Y") {
			enableMenu("cargoLimitsOfLiability");
			disableMenu("itemInfo");
		} else if (parStatus > 2 && checkUserModule("GIPIS005") && (objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == "MN") && sublineCd != "" && opFlag != "Y"){
			enableMenu("itemInfo");
		}
		
		disableMenu("limitsOfLiabilities");
		if(parStatus > 2 && checkUserModule("GIPIS172") && 
				((objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == "AC") || 
				 (objUWGlobal.lineCd == objLineCds.CA || objUWGlobal.menuLineCd == "CA") ||
				  objUWGlobal.lineCd == objLineCds.FI || objUWGlobal.menuLineCd == "FI"  ||
				  objUWGlobal.lineCd == objLineCds.EN || objUWGlobal.menuLineCd == "EN") && 
				 sublineCd != "" && opFlag == "Y") { //Modified by Tonio july 29, 2011 added or condition to include line CA in condition
			enableMenu("limitsOfLiabilities");
			disableMenu("itemInfo");
		} else if (parStatus > 2 && checkUserModule("GIPIS172") && (objUWGlobal.lineCd == objLineCds.AC || objUWGlobal.menuLineCd == "AC") && sublineCd != "" && opFlag != "Y"){			
			enableMenu("itemInfo");
		}	
		
		if ($F("globalIssCd") == $F("globalIssCdRI")) { // Tonio May 24,2011
			disableMenu("enterInvoiceCommission");
		}
		
		if(objUWGlobal.coInsurance != null && objUWGlobal.coInsurance != undefined) objUWGlobal.coInsurance.vStat = parStatus;
		checkCoInsMenu();
		observePostButton(opFlag);
	} catch (e) {
		showErrorMessage("setParMenus", e);
	}
}