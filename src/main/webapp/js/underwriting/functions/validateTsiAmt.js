function validateTsiAmt(){
	try {
		var result = true;
		
		if ("none" != document.getElementById("accPerilDetailsDiv").style.display){
			var baseAmt = $F("perilBaseAmt");
			var noOfDays = $F("perilNoOfDays");
			
			if ("" != baseAmt){
				baseAmt = formatCurrency(baseAmt.replace(/,/g, ""));
			}
			
			noOfDays = noOfDays.replace(/,/g, "");
			
			if (!(("" == baseAmt) || ("0.00" == baseAmt)) && !(("" == noOfDays) || ("0" == noOfDays))){
				showConfirmBox("Edit TSI", "Changing TSI Amount will delete base amount and set number of days to its default value, do you want to continue?", 
						"Yes", "Cancel", function(){
							$("perilBaseAmt").value = "";
							showNoOfDays();
							if(validateTsiAmt2()){
								getPostTextTsiAmtDetails();
							}
						}, function(){
							$("perilTsiAmt").value = $F("varPerilTsiAmt");
						});
				return false;
			} else {
				result = validateTsiAmt2();
			}
		} else {
			result = validateTsiAmt2();
		}
		return result;
	} catch (e){
		showErrorMessage("validateTsiAmt", e);
	}
}