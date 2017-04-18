/*	Created by	: d.alcantara 12.06.2011
 * 	Description	: set the amounts if comm rate is edited
 */
function validateItemPerilCommRate() {
	if(!(isNaN($F("perilRiCommRate")))) {
		if (($F("perilRiCommRate") != "") 
				&& (!(parseFloat($F("perilRiCommRate")) > 100)) 
				&& (!(parseFloat($F("perilRiCommRate")) < 0))){
			$("perilRiCommAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, "") * $F("perilRiCommRate")/100);	
		} else {
			$("perilRiCommAmt").focus();
			$("perilRiCommAmt").value = "";
			showMessageBox("Entered Peril Comm Rate is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
		}
	} else {
		$("perilRiCommAmt").focus();
		$("perilRiCommAmt").value = "";
		showMessageBox("Entered Peril Comm Rate is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
	}
}