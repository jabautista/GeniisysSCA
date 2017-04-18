function getAssuredValues(){
	try {
		$("selectedAssdNo").value = $("assuredNo").value;
		$("selectedAssdName").value = $("assuredName").value;
	
		updateQuoteFromPar();
	} catch (e) {
		showErrorMessage("getAssuredValues", e);
	}
}