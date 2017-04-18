/**
 * Delete item & peril
 * 
 * @author Niknok Orio
 * @param
 */
function deleteClmItem(){
	try{
		var delIndex = objCLMItem.selItemIndex;
		if (nvl(itemGrid,null) instanceof MyTableGrid) itemGrid.deleteAnyRows('divCtrId', delIndex);
		observeClmItemNoFocus();
		if (nvl(perilGrid,null) instanceof MyTableGrid){
			if ($("groPerilInfo").innerHTML == "Hide") fireEvent($("groPerilInfo"), "click");
			perilGrid.clear();
			observeClmItemNoFocus();
		}
		if (nvl(beneficiaryGrid,null) instanceof MyTableGrid){
			if ($("groBenInfo").innerHTML == "Hide") fireEvent($("groBenInfo"), "click");
			beneficiaryGrid.clear();
		}
		clearClmItemForm();
	}catch(e){
		showErrorMessage("deleteClmItem" ,e);
	}
}