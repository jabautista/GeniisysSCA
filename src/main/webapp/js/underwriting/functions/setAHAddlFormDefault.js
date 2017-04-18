function setAHAddlFormDefault() {
	try {
		$("accidentProrateFlag").value = "2";
		//$("accidentProrateFlag").selectedIndex = 1;
		$("accidentCompSw").value = "N";
		showACProrateSpan();
		$("prorateSelectedAccident").hide();
		$("shortRateSelectedAccident").hide();	
		$("personalAdditionalInformationInfo").hide();
	} catch(e) {
		showErrorMessage("setAHAddlFormDefault", e);
	}
}