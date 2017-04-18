/**
 * Check first if any changes in item & peril exists
 * 
 * @author Niknok Orio
 * @param param -
 *            if true clear item no field after message
 * @returns true - if no changes exists
 */
function checkClmItemChanges(param){
	try{
		var ok = true;
		observeClmItemChangeTag(); 
		if (changeTag == 1){
			ok = false;
			objCLMItem.itemLovSw = false;
			if (nvl(itemGrid,null) instanceof MyTableGrid) itemGrid.unselectRows();
			if (nvl(objCLMItem.selItemIndex,null) != null) if (nvl(itemGrid,null) instanceof MyTableGrid) itemGrid.selectRow(String(objCLMItem.selItemIndex));
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				if (nvl(itemGrid,null) instanceof MyTableGrid) itemGrid.unselectRows();
				if (nvl(objCLMItem.selItemIndex,null) != null){
					if (nvl(itemGrid,null) instanceof MyTableGrid){
						itemGrid.selectRow(String(objCLMItem.selItemIndex));
						if (objCLMItem.selected != {} || nvl(objCLMItem.selected,null) != null) $("txtItemNo").value = nvl(unescapeHTML2(String(objCLMItem.selected[itemGrid.getColumnIndex('itemNo')])),"");
					}
				}
				if (nvl(param, false)){
					$("txtItemNo").clear(); 
					if (objCLMItem.itemLovSw){ 
						$("txtItemTitle").clear();
						objCLMItem.itemLovSw = false;
					}
				}
			});
		}
		return ok;
	}catch(e){
		showErrorMessage("checkClmItemChanges", e);	
	}
}