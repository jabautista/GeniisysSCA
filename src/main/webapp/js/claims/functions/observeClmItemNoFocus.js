/**
 * Observe focus event on item no. field
 * 
 * @author Niknok Orio
 * @param
 */
function observeClmItemNoFocus(){
	try{
		initPreTextOnField("txtItemNo");
		$("txtItemNo").observe("focus", function(){
			if (nvl(objCLMItem.selItemIndex,null) < 0){
				checkItemLimit();
			}else{
				if (checkClmItemChanges(nvl(objCLMItem.selItemIndex,null) == null ? true :false)){
					checkItemLimit();
				}
			}
			if (objCLMItem.itemLovSw){
				$("txtItemNo").blur();
			}
		});
	}catch(e){
		showErrorMessage("observeClmItemNoFocus", e);
	}	
}