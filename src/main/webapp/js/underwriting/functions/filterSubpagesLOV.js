/*	Created by	: mark jm 01.07.2011
 * 	Description	: removes/hides lov record that already exists in subpage listing
 * 	Parameter	: itemNo - selected item no
 */
function filterSubpagesLOV(rowName, itemNo){
	var lineCd = getLineCd();
	
	if(lineCd == "MC"){
		if(objMortgagees == null){
			showMortgageeInfoModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), "0");
		}
		if(objGIPIWMcAcc == null && $F("pageName") == "itemInformation"){
			showAccessoryInfoModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), "0");
		}		
		
		if(rowName == "rowMortg"){
			//filterLOV3("mortgageeName", "rowMortg", "mortgCd", "item", itemNo);			
			filterItemLOV("mortgageeTable", "item", itemNo, "mortgageeName", "mortgCd");
		}else if(rowName == "rowAcc"){
			//filterLOV3("selAccessory", "rowAcc", "accCd", "item", itemNo);			
			filterItemLOV("accessoryTable", "item", itemNo, "selAccessory", "accCd");
		}				
	}else if(lineCd == "FI"){
		if(objMortgagees == null){
			showMortgageeInfoModal((objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId")), "0");
		}
		
		filterItemLOV("mortgageeTable", "item", itemNo, "mortgageeName", "mortgCd");
	}else if(lineCd == "MN"){
		if($F("pageName") == "itemInformation"){
			filterItemLOV("cargoCarrierTable", "item", itemNo, "carrierVesselCd", "vesselCd");
		}		
	}
}