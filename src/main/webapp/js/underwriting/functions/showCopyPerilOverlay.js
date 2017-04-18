//marco - 04.10.2013 - copied function from parPerilInfo.jsp
function showCopyPerilOverlay(){
	try{
		if (countPerilsForItem($F("itemNo")) > 0) {
			if ("Y" == $F("copyPerilPageLoaded")){
				$("itemToCopyPeril").update("");
				var selectContent = "<option value=''></option>";
				/*$$("div#parItemTableContainer div[name='rowItem']").each(function(item){
					var itemNo = item.down("input", 1).value;
					if (itemNo != $F("itemNo")){
						selectContent = selectContent + "<option value='"+itemNo+"'>"+itemNo+"</option>";
					}
				});*/
				
				/*for (var i=0; i<objGIPIWItem.length; i++){
					if (objGIPIWItem[i].recordStatus != -1){
						var itemNo = objGIPIWItem[i].itemNo;
						if (itemNo != $F("itemNo")){
							selectContent = selectContent + "<option value='"+itemNo+"'>"+itemNo+"</option>";
						}
					}
				}
				$("itemToCopyPeril").update(selectContent);*/ 
			} 
			//showOverlayContent(contextPath+"/GIPIWItemController?action=showCopyPerilItems&itemNo="+$F("itemNo"), "Copy Peril/s to Item No. ?", "", 450, 100, 450);
			showOverlayContent2(contextPath+"/GIPIWItemPerilController?action=showCopyPerilItems&itemNo="+$F("itemNo"), "Copy Peril/s to Item No. ?", 300, "");
		} else {
			showMessageBox("Item has no existing peril(s) to copy.", imgMessage.INFO);
			return false;
		}
	}catch(e){
		showErrorMessage("showCopyPerilOverlay", e);
	}		
}