function checkIfItemExists(itemNo){	
	var itemNos = ($("itemNumbers") == null) ? "N" : $F("itemNumbers").trim();			// storage for original item nos
	var tempItemNumbers = ($("tempItemNumbers") == null) ? "N" : $F("tempItemNumbers");	// storage for temporary item nos
	if((tempItemNumbers.indexOf(itemNo) < 0) && (itemNos.indexOf(itemNo) < 0)){
		showMessageBox("Please select an item first.", imgMessage.ERROR);
		return false;
	} else{
		return true;
	}
}