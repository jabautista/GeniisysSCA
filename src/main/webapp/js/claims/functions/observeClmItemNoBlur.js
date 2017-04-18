/**
 * Observe blur event on item no. field
 * 
 * @author Niknok Orio
 * @param
 */
function observeClmItemNoBlur(){
	try{
		$("txtItemNo").observe("blur", function(){ 
			if (nvl(objCLMItem.selItemIndex,null) < 0){
				
				if (($F("txtItemNo") != "" && checkIfValueChanged("txtItemNo")) || (objCLMItem.itemLovSw && $F("txtItemNo") != "")){
					var itemNo = objCLMItem.selItemIndex>=0 ? unescapeHTML2(String(itemGrid.rows[objCLMItem.selItemIndex][itemGrid.getColumnIndex('itemNo')])) :unescapeHTML2(String(itemGrid.newRowsAdded[Math.abs(objCLMItem.selItemIndex)-1][itemGrid.getColumnIndex('itemNo')]));
					
					if ($F("txtItemNo") != itemNo){
						/*
						 * showConfirmBox("Confirm", "Item information will be
						 * replaced and corresponding peril and beneficiary
						 * records deleted. Continue?", "Yes", "No", function(){
						 * if (nvl(perilGrid,null) instanceof MyTableGrid){
						 * perilGrid.clear(); observeClmItemNoFocus(); if
						 * ($("groPerilInfo").innerHTML == "Hide")
						 * fireEvent($("groPerilInfo"), "click");
						 * //getClmItemPeril($F("txtItemNo")); }else{
						 * clearClmItemPerilForm(); } validateClmItemNo(); },
						 * function(){ $("txtItemNo").value =
						 * objCLMItem.selected[itemGrid.getColumnIndex('itemNo')];
						 * validateClmItemNo(); } );
						 */ // comment ko muna ilipat ko nalang muna ito sa
								// click add/update button para di idelete agad
								// si perils - nok
						validateClmItemNo();
					}else{
						validateClmItemNo();
					}
				}
			}else{
				if (checkClmItemChanges(true)){
					if (($F("txtItemNo") != "" && checkIfValueChanged("txtItemNo")) || (objCLMItem.itemLovSw && $F("txtItemNo") != "")){
						if(objCLMGlobal.lineCd == "PA" || objCLMGlobal.menuLineCd == objLineCds.AC  ){//belle 05.15.2012
							clearItemGrpDtls(); 
							validateClmItemNo();
						}else{
							validateClmItemNo();
						}
					}
				}
			}
			objCLMItem.itemLovSw = false;
		});
	}catch(e){
		showErrorMessage("observeClmItemNoBlur", e);
	}
}