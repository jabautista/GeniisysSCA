/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validateItemPerilRate(){
	try{
		if ($F("perilRate") == ""){
			$("perilRate").focus();
			showMessageBox("Peril Rate is required.", "error");
		} else if (!(isNaN($F("perilRate")))){
			if (($F("perilRate") != "") 
					&& (!(parseFloat($F("perilRate")) > 100)) 
					&& (!(parseFloat($F("perilRate")) < 0))){
				if((objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN) && "Y" == $F("markUpTag")){
					$("perilRate").value = formatToNineDecimal($F("perilRate")); 
					$("perilTsiAmt").value = formatCurrency(($F("invCurrRt")*$F("invoiceValue").replace(/,/g, ""))+($F("invCurrRt")*$F("invoiceValue").replace(/,/g, "")*$F("markupRate")/100));
					$("premiumAmt").value = formatCurrency($("perilTsiAmt").value.replace(/,/g, "") * $F("perilRate")/100);
					$("perilRiCommAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, "") * $F("perilRiCommRate")/100);
				} else {
					$("tempPerilRate").value = $F("perilRate");
					$("perilRate").value = formatToNineDecimal($F("perilRate"));
					$("premiumAmt").value = computePerilPremAmount($F("prorateFlag"), $F("perilTsiAmt"), $F("perilRate"));
					$("perilRiCommAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, "") * $F("perilRiCommRate")/100);
				}
			} else {
				$("perilRate").focus();
				$("perilRate").value = "";
				showMessageBox("Entered Peril Rate is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
			}
		} else {
			$("perilRate").focus();
			$("perilRate").value = "";
			showMessageBox("Entered Peril Rate is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
		}
	}catch(e){
		showErrorMessage("validateItemPerilRate", e);
	}	
}