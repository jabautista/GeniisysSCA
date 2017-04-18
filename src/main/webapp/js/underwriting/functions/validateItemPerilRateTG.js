/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.21.2011	mark jm			table grid version of validateItemPerilRate
 */
function validateItemPerilRateTG(){
	try{
		if ($F("perilRate") == ""){
			$("perilRate").focus();
			showMessageBox("Peril Rate is required.", "error");
		} else if (!(isNaN($F("perilRate")))){
			if (($F("perilRate") != "") 
					&& (!(parseFloat($F("perilRate")) > 100)) 
					&& (!(parseFloat($F("perilRate")) < 0))){
				if((objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN) && ("Y" == objFormVariables.markupTag || "Y" == objFormVariables.varMarkupTag)){
					// conditions added by: Nica 07.19.2012 - to compute according to markup rate
					if(nvl($F("invCurrRt"), "") != "" && nvl($F("invoiceValue"), "") != "" && nvl($F("markupRate"), "") != ""){ 
						$("perilRate").value = formatToNineDecimal($F("perilRate")); 
						$("perilTsiAmt").value = formatCurrency(($F("invCurrRt")*$F("invoiceValue").replace(/,/g, ""))+($F("invCurrRt")*$F("invoiceValue").replace(/,/g, "")*$F("markupRate")/100));
						//$("premiumAmt").value = formatCurrency($("perilTsiAmt").value.replace(/,/g, "") * $F("perilRate")/100);
						$("premiumAmt").value = computePerilPremAmount( objUWParList.prorateFlag, $F("perilTsiAmt"), $F("perilRate")); //modified by gab 07.19.2016 SR 21693
						$("perilRiCommAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, "") * $F("perilRiCommRate")/100);
					}else{
						$("tempPerilRate").value = $F("perilRate");
						$("perilRate").value = formatToNineDecimal($F("perilRate"));
						$("premiumAmt").value = computePerilPremAmount( objUWParList.prorateFlag, $F("perilTsiAmt"), $F("perilRate"));
						$("perilRiCommAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, "") * $F("perilRiCommRate")/100);
					}
				} else {
					$("tempPerilRate").value = $F("perilRate");
					$("perilRate").value = formatToNineDecimal($F("perilRate"));
					$("premiumAmt").value = computePerilPremAmount( objUWParList.prorateFlag, $F("perilTsiAmt"), $F("perilRate"));
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
		showErrorMessage("validateItemPerilRateTG", e);
	}	
}