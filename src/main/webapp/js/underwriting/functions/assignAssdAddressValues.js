function assignAssdAddressValues(){
	try{
		$("mailAddress1").value = $F("mailAddress1Overlay");
		$("mailAddress2").value = $F("mailAddress2Overlay");
		$("mailAddress3").value = $F("mailAddress3Overlay");
		$("billAddress1").value = $F("billingAddress1Overlay");
		$("billAddress2").value = $F("billingAddress2Overlay");
		$("billAddress3").value = $F("billingAddress3Overlay");
		$("phoneNo").value = $F("phoneNoOverlay");
	}catch(e){
		showErrorMessage("assignAssdAddressValues",e);
	}
}