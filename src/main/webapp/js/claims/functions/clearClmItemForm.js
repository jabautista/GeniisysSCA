/**
 * Clear claims item information
 * 
 * @author Niknok Orio
 * @param
 */
function clearClmItemForm(){
	try{
		if(objCLMGlobal.lineCd == "FI" || objCLMGlobal.lineCd == objLineCds.FI){ 
			supplyClmFireItem(null);
		}else if(objCLMGlobal.lineCd == "MC" || objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC){// added
																						// for
																						// MC
																						// Line
																						// -
																						// Irwin
			populateMotorCarFields(null);
		}else if(objCLMGlobal.lineCd == "CA" || objCLMGlobal.lineCd == objLineCds.CA || objCLMGlobal.menuLineCd == objLineCds.CA|| objCLMGlobal.lineCd == "LI" || objCLMGlobal.lineCd == objLineCds.LI){//added by steven 10/30/2012
			supplyClmCasualtyItem(null);
		}else if(objCLMGlobal.lineCd == "MN" || objCLMGlobal.lineCd == objLineCds.MN || objCLMGlobal.menuLineCd == objLineCds.MN){ // added
																						// for
																						// MN
																						// Line
																						// -
																						// Irwin
			populateMarineCargoFields(null);
		}else if(objCLMGlobal.lineCd == "AV" || objCLMGlobal.lineCd == objLineCds.AV || objCLMGlobal.menuLineCd == objLineCds.AV){ // added
																						// for
																						// AV -
																						// Irwin
			populateAviationFields(null);
		} else if(objCLMGlobal.lineCd == "PA" || objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC || objCLMGlobal.lineCd == "AH"  || objCLMGlobal.menuLineCd == "AC"){ // added
																						// for
																						// AV -
																						// belle 12022011
			populateAccidentFields(null);
		} else if(objCLMGlobal.lineCd == "MH" || objCLMGlobal.lineCd == objLineCds.MH || objCLMGlobal.menuLineCd == objLineCds.MH){
			clearMarineHullItems();
			redefaultItemButtons();
		}else if(objCLMGlobal.lineCd == "EN" || objCLMGlobal.lineCd == objLineCds.EN || objCLMGlobal.menuLineCd == objLineCds.EN){
			supplyClmEngineeringItem(null);
		}
		objCLMItem.selected 	= {};
		objCLMItem.newItem		= [];
		objCLMItem.selItemIndex	= null;
		objCLMItem.itemLovSw 	= false;
		objCLMItem.grpItemLovSw = false;
		observeClmItemChangeTag(); 
		if (nvl(itemGrid,null) instanceof MyTableGrid) itemGrid.unselectRows(); 
	}catch(e){
		showErrorMessage("clearClmItemForm", e);	
	}
}