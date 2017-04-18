/**
 * Add new item info record per line code
 * 
 * @author Niknok Orio
 * @param
 */
function addClmItemPerLine(){
	try{
		if(objCLMGlobal.lineCd == "FI" || objCLMGlobal.lineCd == objLineCds.FI || objCLMGlobal.menuLineCd == objLineCds.FI){ 
			addClmFireItem();
		}else if(objCLMGlobal.lineCd == "MC" || objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC){
			addClmMotorCarItem();
			validateItemTableGrid(); // for the LOV icon *Rey
		}else if(objCLMGlobal.lineCd == "CA" || objCLMGlobal.lineCd == objLineCds.CA || objCLMGlobal.menuLineCd == objLineCds.CA || objCLMGlobal.lineCd == "LI" || objCLMGlobal.lineCd == objLineCds.LI){//added by steven 10/30/2012
			addClmCasualtyItem();
			validateItemTableGrid(); // for the LOV icon *Rey
		}else if(objCLMGlobal.lineCd == "EN" || objCLMGlobal.lineCd == objLineCds.EN || objCLMGlobal.menuLineCd == objLineCds.EN) {
			addClmEngineeringItem();
			validateItemTableGrid(); // for the LOV icon *Rey
		}else if(objCLMGlobal.lineCd == "MH" || objCLMGlobal.lineCd == objLineCds.MH || objCLMGlobal.menuLineCd == objLineCds.MH){
			addClmMarineHullItem();
			validateItemTableGrid(); // for the LOV icon *Rey
			redefaultItemButtons();
		}/*else if(objCLMGlobal.lineCd == "MN" || objCLMGlobal.lineCd == objLineCds.MN) {
			addClmMarineCargoItem();
		}*/else{// for lines AV and MN - Irwin Tabisora
			addClmItem();
			showHideItemNoDate(); //belle 02.10.2012 disallow user to make changes
		}
	}catch(e){
		showErrorMessage("addClmItemPerLine", e);
	}
}