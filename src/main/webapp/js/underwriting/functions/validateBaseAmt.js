/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validateBaseAmt(){
	try {
		var baseAmt = nvl($F("perilBaseAmt").replace(/,/g , ""), 0);
		var noOfDays = nvl($F("perilNoOfDays"), 0);
		if ("none" != document.getElementById("accPerilDetailsDiv").style.display){
			if ("" != baseAmt){
				if ((isNaN(baseAmt)) || ((baseAmt.split(".")).size > 2)){
					$("perilBaseAmt").focus();
					$("perilBaseAmt").value = "";
					showMessageBox("Entered Base Amount is invalid. Valid value is from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR);
				} else if ((parseFloat(baseAmt) > 99999999999999.99) || (parseFloat(baseAmt) < 0)){
					$("perilBaseAmt").focus();
					$("perilBaseAmt").value = "";
					showMessageBox("Entered Base Amount is invalid. Valid value is from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR);
				} else {
					/*if (($F("perilNoOfDays") == "") || ($F("perilNoOfDays") == "0")){
						$("perilBaseAmt").value = formatCurrency(parseFloat(baseAmt));
					} else {
						$("perilTsiAmt").value = noOfDays * baseAmt;
						getPostTextTsiAmtDetails();
						//$("perilBaseAmt").value = formatCurrency($F("perilBaseAmt").replace(/,/g , ""));
						$("perilBaseAmt").value = formatCurrency(parseFloat(baseAmt));
					}*/ // replaced by: Nica 04.22.2013- to recompute TSI amount even if perilNoOfDays = 0
					
					$("perilTsiAmt").value = noOfDays * baseAmt;
					getPostTextTsiAmtDetails();
					$("perilBaseAmt").value = formatCurrency(parseFloat(baseAmt));
				}
			}
		}
	} catch(e){
		showErrorMessage("validateBaseAmt", e);
	}
}