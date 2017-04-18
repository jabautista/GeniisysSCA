function isItemInfoValid() {
	try {
		var tempRows = $("parItemTableContainer").childElements(); 
		var exist = false;

		for(var i=0; i<tempRows.length; i++){
			if(tempRows[i].down("label", 0).innerHTML.trim() == $F("itemNo")){
				exist = true;
			}
		}
		
		if($F("itemNo").blank()){
			showMessageBox("Item Number is required.", imgMessage.ERROR);						
			return false;
		} else if($F("btnAddItem") == "Add" && exist == true){
			showMessageBox("Item Number already exists.", imgMessage.ERROR);
			return false;		
		} else if($F("currency").blank() || "0.000000000" == $F("rate")){
			showMessageBox("Currency rate is required.", imgMessage.ERROR);
			return false;
		} else if($F("rate").match("-") || $F("rate").blank()) {
			showMessageBox("Invalid currency rate.", imgMessage.ERROR);
			return false;
		} else if($F("itemTitle").blank() || $F("itemTitle") == "") {
			showMessageBox("Please enter the item title first.", imgMessage.ERROR);
			return false;
		} else if ($F("region").blank()) {
			showMessageBox("Region is required.", imgMessage.ERROR);
			return false;			
		} else if($F("recFlag") == "A") {
			var emptySelect = false;
			var selectId = "";
			
			$$("div#additionalItemInformation select[class='required']").each(function(sel){
				if (sel.value == "") {
					emptySelect = true;
					selectId = sel.id;					
				}
			});
			if (emptySelect) {
				showMessageBox("Please complete additional information for Item No. "+$F("itemNo")+" before saving.", imgMessage.INFO);
				return false;
			}
		}	
		return true;
	} catch (e) {
		showErrorMessage("isItemInfoValid", e);
		//showMessageBox("isItemInfoValid : " + e.message);
	}
}