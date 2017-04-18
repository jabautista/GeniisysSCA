/*	Created by	: d.alcantara 12.06.2011
 * 	Description	: set the amounts if comm amt is edited
 */
function validateItemPerilCommAmt() {
	var commAmt = parseFloat($F("premiumAmt").replace(/,/g, ""));
	var premAmt = parseFloat($F("premiumAmt").replace(/,/g, ""));
		
	if(!(isNaN(commAmt))){
		if (($F("perilRiCommAmt")!="") && !(premAmt < 0.00) && !(commAmt > 999999999999.99)){
			$("perilRiCommRate").value = $F("perilRiCommAmt").replace(/,/g, "")*100 / $F("premiumAmt").replace(/,/g, "");
		} else {
			$("premiumAmt").focus();
			$("premiumAmt").value = "";
			showMessageBox("Entered Premium Amount is invalid. Valid value is from 0.00 to 999,999,999,999.99.", imgMessage.ERROR);
		}
	} else {
		$("premiumAmt").focus();
		$("premiumAmt").value = "";
		showMessageBox("Entered Premium Amount is invalid. Valid value is from 0.00 to 999,999,999,999.99.", imgMessage.ERROR);
	}
}