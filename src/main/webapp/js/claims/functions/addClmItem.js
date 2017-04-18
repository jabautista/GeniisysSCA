/**
 * Add new claim item
 * 
 * @author Niknok Orio
 * @param
 */
function addClmItem(){
	try{
		
		if ($F("txtItemNo") == ""){
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtItemNo");
			return false;
		}
		//belle 05.15.2012
		if(objCLMGlobal.lineCd == objLineCds.AC || objCLMGlobal.menuLineCd == "AC"){ 
			if ($F("txtItemNo") == "" || $F("txtGrpItemNo") == ""){
				customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtGrpItemNo");
				return false;
			}
		}
		
		if (objCLMItem.newItem == [] || nvl(objCLMItem.newItem,null) == null){
			return false;
		}
		
		if (objCLMItem.deletePerilSw){
			if (nvl(perilGrid,null) instanceof MyTableGrid){
				perilGrid.clear();
				observeClmItemNoFocus();
				if ($("groPerilInfo").innerHTML == "Hide") fireEvent($("groPerilInfo"), "click");
				// getClmItemPeril($F("txtItemNo"));
			}else{
				clearClmItemPerilForm();
			}
		}		
		
		if ($("btnAddItem").value == "Update"){
			itemGrid.deleteRow(objCLMItem.selItemIndex);
		}
		itemGrid.createNewRows(objCLMItem.newItem); 
		itemGrid.selectRow(-1);
		clearClmItemForm();
		if ($("myTableGrid1")) $("myTableGrid1").scrollIntoView();
	}catch(e){
		showErrorMessage("addClmItem", e);
	}
}