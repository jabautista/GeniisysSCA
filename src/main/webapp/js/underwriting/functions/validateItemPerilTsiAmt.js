/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validateItemPerilTsiAmt(){
	try {
		var tsiAmt = ($F("perilTsiAmt")).replace(/,/g, "");
		if (tsiAmt == ""){
			$("perilTsiAmt").focus();
			showMessageBox("TSI Amount is required.", imgMessage.ERROR);
		} else if((isNaN(tsiAmt)) || (tsiAmt.split(".").size > 2)){
			/*$("perilTsiAmt").focus();
			$("perilTsiAmt").value = "";
			showMessageBox("Invalid TSI amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);*/
			clearFocusElementOnError("perilTsiAmt", "Invalid TSI amount. Value should be from 0.01 to 99,999,999,999,999.99.");
		} else if ((parseFloat(tsiAmt) < 0.01) || (parseFloat(tsiAmt) > 99999999999999.99)) {
			$("perilTsiAmt").focus();
			$("perilTsiAmt").value = "";
			showMessageBox("Invalid TSI amount. Value should be from 0.01 to 99,999,999,999,999.99.", imgMessage.ERROR);
		} else {			
			if (validatePerilTsiAmt()){				//here
				//getPostTextTsiAmtDetails2(); commented out by Gzelle 11242014
				if ($("globalWithTariffSw").value == "Y") { //Tariff
					getDefPerilAmts("perilTsiAmt");
				} else { //Non-Tariff
					getPostTextTsiAmtDetails2();
				}
			}
		}
	} catch (e){
		showErrorMessage("validateItemPerilTsiAmt", e);
	}
}