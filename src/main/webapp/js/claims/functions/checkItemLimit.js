/**
 * Check limit on creating item record
 * 
 * @author Niknok Orio
 * @param
 */
function checkItemLimit(){
	try{
		if (Number(objCLMGlobal.itemLimit) == Number(itemGrid.pager.total) && (nvl(objCLMItem.selItemIndex,null) == null || $("btnAddItem").value == "Add")){
			if ($("itemNoDate").getStyle("display") != "none") showMessageBox("This is the last record allowable.", "I");
			if (nvl(objCLMItem.selItemIndex,null) == null) $("txtItemNo").clear();
			$("txtItemNo").blur();
			if (objCLMItem.itemLovSw){
				objCLMItem.itemLovSw = false;
				$("txtItemTitle").clear();
			}
			return false;
		}
		return true;
	}catch(e){
		showErroMessage("checkItemLimit", e);
	}
}