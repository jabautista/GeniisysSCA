function validateMNItems(){
	for(var i=0; i<objEndtMNItems.length; i++){
		if(objEndtMNItems[i].recFlag == "A" && objEndtMNItems[i].geogCd == null){
			if ($("row"+objEndtMNItems[i].itemNo) != null) {
				showMessageBox("Item "+objEndtMNItems[i].itemNo+" has no cargo information specified, please enter the necessary information.");
				if (!$("row"+objEndtMNItems[i].itemNo).hasClassName("selectedRow")) {
					fireEvent($("row"+objEndtMNItems[i].itemNo), "click");
				}
				$("row"+objEndtMNItems[i].itemNo).scrollTo();
				return false;
			}
		}
	}
	return true; 
}