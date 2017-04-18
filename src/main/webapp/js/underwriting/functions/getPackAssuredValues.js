function getPackAssuredValues(){
	try {
		//$("selectedAssdNo").value = $("assuredNo").value;
		//$("selectedAssdName").value = $("assuredName").value;
		hideOverlay();
		if($("fromPackQuotation")!=null && $F("fromPackQuotation") == 'Y'){
			savePackPAR('P', '');
			//checkIfLineSublineExist();
		}
		
		//enableParCreationButtons();
	} catch (e) {
		showErrorMessage("getPackAssuredValues", e);
	}
}