/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validatePerilTsiAmt(){
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
							/*$("perilBaseAmt").value = "";
							showNoOfDays();*/ // replaced by: Nica 04.16.2013
							$("perilBaseAmt").value = formatCurrency(0); // added by: Nica 04.11.2013
							$("perilNoOfDays").value = 0; // to reset values of base amt and no of days to zero for AC line
							$("perilBaseAmt").value = formatCurrency(0); // added by: Nica 04.11.2013
							$("perilNoOfDays").value = 0; // to reset values of base amt and no of days to zero for AC line
							if(validatePerilTsiAmt2()){
								getPostTextTsiAmtDetails();
							}
						}, function(){
							$("perilTsiAmt").value = $F("varPerilTsiAmt");
						});
				return false;
			} else {
				$("perilBaseAmt").value = formatCurrency(0); // added by: Nica 04.11.2013
				$("perilNoOfDays").value = 0; // to reset values of base amt and no of days to zero for AC line
				result = validatePerilTsiAmt2();
			}
		} else {
			result = validatePerilTsiAmt2();
		}
		return result;
	} catch (e){
		showErrorMessage("validatePerilTsiAmt", e);
	}
}