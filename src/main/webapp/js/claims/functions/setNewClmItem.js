/**
 * Set new item record
 * 
 * @author Niknok Orio
 * @param new
 *            item record
 */
function setNewClmItem(newItem){
	try{
		if(objCLMGlobal.lineCd == "FI" || objCLMGlobal.lineCd == objLineCds.FI || objCLMGlobal.menuLineCd == objLineCds.FI){
			supplyClmFireItem(newItem);
		}else if(objCLMGlobal.lineCd == "MC" || objCLMGlobal.lineCd == objLineCds.MC){// Added
																						// for
																						// Motor
																						// Car.
																						// Irwin
																						// 9.22.11
			populateMotorCarFields(newItem);
		}else if(objCLMGlobal.lineCd == "CA" || objCLMGlobal.lineCd == objLineCds.CA  || objCLMGlobal.lineCd == "LI" || objCLMGlobal.lineCd == objLineCds.LI || objCLMGlobal.menuLineCd == objLineCds.CA){//added by steven 10/30/2012
			supplyClmCasualtyItem(newItem);
		}else if(objCLMGlobal.lineCd == "EN" || objCLMGlobal.lineCd == objLineCds.EN || objCLMGlobal.menuLineCd == objLineCds.EN) {// Added
																						// for
																						// Engineering.
																						// Emman
																						// 9.30.11
			supplyClmEngineeringItem(newItem);
		}else if(objCLMGlobal.lineCd == "MN" || objCLMGlobal.lineCd == objLineCds.MN || objCLMGlobal.menuLineCd == objLineCds.MN){// Added
																						// for
																						// Motor
																						// Car.
																						// Irwin
																						// 9.22.11
			populateMarineCargoFields(newItem);
		}else if(objCLMGlobal.lineCd == "AV" || objCLMGlobal.lineCd == objLineCds.AV || objCLMGlobal.menuLineCd == objLineCds.AV){// Added for Aviation. Irwin 10.11.11
			populateAviationFields(newItem);
		}else if(objCLMGlobal.lineCd == "PA" || objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.lineCd == "AH" || objCLMGlobal.menuLineCd == "AC"){// Added for Accident Belle 12.05.2011
			populateAccidentFields(newItem); 
		}else if(objCLMGlobal.lineCd == "MH" || objCLMGlobal.lineCd == objLineCds.MH || objCLMGlobal.menuLineCd == objLineCds.MH){// Added by Rey for Marine Hull 01-12-2011
			supplyClmMarineHullItem(newItem);											
		}
			
	}catch(e){
		showErrorMessage("setNewClmItem" ,e);
	}
}