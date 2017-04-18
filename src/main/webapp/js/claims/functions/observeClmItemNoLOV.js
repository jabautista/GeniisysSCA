/**
 * Create observe for Item No. LOV
 * 
 * @author Niknok Orio
 * @param
 */
function observeClmItemNoLOV(){
	try{
		$("itemNoDate").observe("click", function(){
			if (objCLMItem.selected != {} || objCLMItem.selected != null) if (unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilExist')]) == "Y") return;
			showClmItemNoLOV();
		});
	}catch(e){
		showErrorMessage("observeClmItemNoLOV", e);
	}
}