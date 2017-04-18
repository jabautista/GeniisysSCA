/**
 * Getting claim item module id
 * 
 * @author Niknok Orio
 */
function getClaimItemModuleId(lineCd){ // , menuLineCd){
	// if(lineCd == objLineCds.FI || menuLineCd == objLineCds.FI) {
	if(lineCd == "FI" || lineCd == objLineCds.FI || objCLMGlobal.menuLineCd == objLineCds.FI){
		return claimItemModuleId.FIRE;
	}else if(lineCd == "MC" || lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC){
		return claimItemModuleId.MOTORCAR;
	}else if(lineCd == "CA" || lineCd == objLineCds.CA || objCLMGlobal.menuLineCd == objLineCds.CA || lineCd == "LI" || lineCd == objLineCds.LI){//added by steven 10/30/2012
		return claimItemModuleId.CASUALTY;
	}else if(lineCd == "EN" || lineCd == objLineCds.EN || objCLMGlobal.menuLineCd == objLineCds.EN){
		return claimItemModuleId.ENGINEERING;
	}else if(lineCd == "MN" || lineCd == objLineCds.MN || objCLMGlobal.menuLineCd == objLineCds.MN){
		return claimItemModuleId.MARINECARGO;
	}else if(lineCd == "AV" || lineCd == objLineCds.AV || objCLMGlobal.menuLineCd == objLineCds.AV){
		return claimItemModuleId.AVIATION;
	}else if(lineCd == "MH" || lineCd == objLineCds.MH || objCLMGlobal.menuLineCd == objLineCds.MH){//Rey 11-28-2011
		return claimItemModuleId.MARINEHULL;
	}else if(lineCd == "PA" || lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC"){
		return claimItemModuleId.ACCIDENT;
	}
}