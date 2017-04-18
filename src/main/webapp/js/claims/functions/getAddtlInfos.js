/**
 * Getting additional info's
 * 
 * @author Niknok Orio
 * @param item
 *            current object
 */
function getAddtlInfos(obj){
	try{
		//$("btnAddItem").value = obj != null && objCLMItem.selItemIndex ? "Update" :"Add"; // belle 02.10.2012 wala na daw Update
		
		$("groPerilStatus").innerHTML == "Hide" ? fireEvent($("groPerilStatus"), "click") : null;
		
		if (nvl($("groMortgagee"), null) != null) {
			$("groMortgagee").innerHTML == "Hide" ? fireEvent($("groMortgagee"), "click") :null;
		}
		
		disableSubpage("groPerilStatus");
		enableButton("btnDeleteItem");
		enableButton("btnAddItem");
		
		if (obj != null){			
			if (nvl(unescapeHTML2(obj[itemGrid.getColumnIndex('giclItemPerilExist')]),"N") == "Y"){ 
				enableSubpage("groPerilStatus");
			}else{
				disableSubpage("groPerilStatus");
			}
			
			if (nvl($("mortgageeInfoMainDiv"), null) != null) {  
				if (unescapeHTML2(obj[itemGrid.getColumnIndex('giclMortgageeExist')]) == "Y"){
					enableSubpage("groMortgagee");
				}else{
					disableSubpage("groMortgagee");
				}
			}
			if (!checkPerilChanges()){
				getClmItemPeril($F("txtItemNo"));
			} 
			
			//added by Nok disable na daw si Update button 02.13.12
			if (nvl(objCLMItem.selItemIndex,null) != null){
				disableButton("btnAddItem");
				if(objCLMGlobal.lineCd == "FI" || objCLMGlobal.lineCd == objLineCds.FI){
					$("itemNoDate").show(); 
				}else{
					$("itemNoDate").hide(); 
				}				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
				$("txtItemNo").readOnly = true;
				if (objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC){ 
					if ($("grpItemNo")) $("grpItemNo").hide();
					$("txtGrpItemNo").readOnly = true;
				}
			}else{
				enableButton("btnAddItem");
				$("itemNoDate").show();
				$("txtItemNo").readOnly = false;
				if (objCLMItem.lineCd == objLineCds.AC || objCLMItem.menuLineCd == objLineCds.AC){ 
					if ($("grpItemNo")) $("grpItemNo").show();
					$("txtGrpItemNo").readOnly = false;
				}
			}
		}else{
			if (nvl($("mortgageeInfoMainDiv"), null) != null) {
				disableSubpage("groMortgagee");
			}
			
			$("txtItemNo").readOnly = false;
			disableButton("btnDeleteItem");
			$("itemNoDate").show();
			if (objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == objLineCds.AC){ 
				$("grpItemNo").show(); 
			}
			if (checkPerilChanges()){
				if ($("groPerilInfo").innerHTML == "Show"){
					// $("perilInfoDiv").innerHTML = "";
					// $("groPerilInfo").hide();
					// $("loadPerilInfo").show();
					// $("groPerilInfo").innerHTML = "Hide";
				}else{
					$("groPerilInfo").innerHTML = "Show";
					var infoDiv = $("groPerilInfo").up("div", 1).next().readAttribute("id");
					Effect.toggle(infoDiv, "blind", {
						duration: .3
					});
				}
				/*
				 * var infoDiv = $("groPerilInfo").up("div",
				 * 1).next().readAttribute("id"); Effect.toggle(infoDiv, "blind", {
				 * duration: .3 });
				 */
			}else{
				$("groPerilInfo").innerHTML == "Hide" ? fireEvent($("groPerilInfo"), "click") :null;
				getClmItemPeril(null);
			}
			//belle 02.16.2012
			if (objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC"){
				if (checkBeneficiaryChanges()){
					if ($("groBenInfo").innerHTML == "Show"){
					
					}else{
						$("groBenInfo").innerHTML = "Show";
						var infoDiv = $("groBenInfo").up("div", 1).next().readAttribute("id");
						Effect.toggle(infoDiv, "blind", {
							duration: .3
						});
					}
				}else{
					$("groBenInfo").innerHTML == "Hide" ? fireEvent($("groBenInfo"), "click") :null;
					getClaimItemBenInfo();
				}
			}
			clearClmItemPerilForm();
		}
	}catch(e){
		showErrorMessage("getAddtlInfos", e);
	}
}