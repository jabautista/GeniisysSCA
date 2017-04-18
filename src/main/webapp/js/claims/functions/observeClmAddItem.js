/**
 * Create observe in Add button in Claim item information
 * 
 * @author Niknok Orio
 * @param
 */
function observeClmAddItem(){
	try{
		$("btnAddItem").observe("click", function(){
			
			objCLMItem.deletePerilSw = false;
			if ($("btnAddItem").value == "Update"){
				var itemNo = objCLMItem.selItemIndex>=0 ? unescapeHTML2(String(itemGrid.rows[objCLMItem.selItemIndex][itemGrid.getColumnIndex('itemNo')])) :unescapeHTML2(String(itemGrid.newRowsAdded[Math.abs(objCLMItem.selItemIndex)-1][itemGrid.getColumnIndex('itemNo')]));
				var hasPeril = objCLMItem.selItemIndex>=0 ? unescapeHTML2(String(itemGrid.rows[objCLMItem.selItemIndex][itemGrid.getColumnIndex('giclItemPerilExist')])) :unescapeHTML2(String(itemGrid.newRowsAdded[Math.abs(objCLMItem.selItemIndex)-1][itemGrid.getColumnIndex('giclItemPerilExist')]));
				
				if (nvl(hasPeril,"N") == "N"){
					if (nvl(perilGrid,null) instanceof MyTableGrid){
						if (perilGrid.getModifiedRows().length != 0 || perilGrid.getNewRowsAdded().length != 0){
							hasPeril = "Y";
						}
					}
				}
				if ($F("txtItemNo") != itemNo && nvl(hasPeril,"N") == "Y"){
					showConfirmBox("Confirm", "Item information will be replaced and corresponding peril and beneficiary records deleted. Continue?",
							"Yes", "No", 
							function(){
								/*
								 * if (nvl(perilGrid,null) instanceof
								 * MyTableGrid){ perilGrid.clear();
								 * observeClmItemNoFocus(); if
								 * ($("groPerilInfo").innerHTML == "Hide")
								 * fireEvent($("groPerilInfo"), "click");
								 * //getClmItemPeril($F("txtItemNo")); }else{
								 * clearClmItemPerilForm(); }
								 */
								objCLMItem.deletePerilSw = true;
								addClmItemPerLine();
							}, 
							function(){
								$("txtItemNo").value = objCLMItem.selected[itemGrid.getColumnIndex('itemNo')];
								validateClmItemNo();
							}
					);
				}else{
					addClmItemPerLine();
				}
			}else{
				if (checkClmItemChanges(nvl(objCLMItem.selItemIndex,null) == null ? true :false)){
					if (objCLMGlobal.itemLimit == itemGrid.pager.total && (nvl(objCLMItem.selItemIndex,null) == null || $("btnAddItem").value == "Add")){
						showMessageBox("This is the last record allowable.", "I");
						if (nvl(objCLMItem.selItemIndex,null) == null) $("txtItemNo").clear();
						$("txtItemNo").blur();
						return false;
					}else{
						//modified by kenneth 11.18.2014 to avoid error when item is null and add button is pressed
						if($F("txtItemNo") == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtItemNo");
						}else{
							addClmItemPerLine();
						}
					}
				}
			}
		});
		
	}catch(e){
		showErrorMessage("observeClmAddItem", e);
	}	
}