/**
 * Create observe in Attache/View Pictures button in Claim item information
 * 
 * @author Niknok Orio
 * @param
 */
function observeClmItemAttachMedia(){
	try{
		$("btnAttachViewPic").observe("click", function (){
			if (checkClmItemChanges()){
				if (nvl(objCLMItem.selItemIndex,null) == null){
					showMessageBox("Please select item first.", "I");
					return false;
				}
				if (objCLMItem.selected != {} || objCLMItem.selected != null){
					var itemNo = objCLMItem.selItemIndex>=0 ? unescapeHTML2(String(itemGrid.rows[objCLMItem.selItemIndex][itemGrid.getColumnIndex('itemNo')])) :unescapeHTML2(String(itemGrid.newRowsAdded[Math.abs(objCLMItem.selItemIndex)-1][itemGrid.getColumnIndex('itemNo')]));
					if ($F("txtItemNo") != itemNo && $("btnAddItem").value == "Update"){
						showMessageBox("Please update item first.", "I");
						return false;
					}
				}
				//openAttachMediaModal("clmItemInfo");
				openAttachMediaOverlay("clmItemInfo"); //SR-5494 JET OCT-17-2016
			}
		});
	}catch(e){
		showErrorMessage("observeClmItemAttachMedia", e);
	}
}