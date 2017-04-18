/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function validateItemPerilPremAmt(){
	try{
		var premAmt		= parseFloat($F("premiumAmt").replace(/,/g, ""));
		var perilTsiAmt	= parseFloat($F("perilTsiAmt").replace(/,/g, ""));
		var perilRate   = null;
		
		if ($F("premiumAmt") == ""){
			$("premiumAmt").focus();
			showMessageBox("Premium Amount is required.", imgMessage.ERROR);
		} else if(!(isNaN($F("premiumAmt")))){
			if (($F("premiumAmt")!="") && !(premAmt < 0.00) && !(premAmt > 99999999999999.99)){
				if (($F("perilTsiAmt")!="") && (!(perilTsiAmt < 0.00)) && (!(perilTsiAmt > 99999999999999.99))){
					if (!(premAmt > perilTsiAmt)){
						/*computeItmPerilRate(); //belle 04.24.2012 replaced by codes below
					 	$("tempPremAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, ""));
						$("perilRiCommAmt").value = formatCurrency(premAmt * ($F("perilRiCommRate")/100));*/
						perilRate = computeItmPerilRate();
						if (perilRate > 100){
							$("perilRate").value = "";
							$("premiumAmt").value = objCurrItemPeril == null ? "" : objCurrItemPeril.premAmt; //objCurrItemPeril.premAmt belle 04.25.2012
							showMessageBox("Premium Rate (" +perilRate+ ") exceeds 100%, please check your Premium Computation Conditions at Basic Information Screen", imgMessage.ERROR);
						}else{
							$("perilRate").value = perilRate;
							$("tempPremAmt").value = formatCurrency($F("premiumAmt").replace(/,/g, ""));
							$("perilRiCommAmt").value = formatCurrency(premAmt * ($F("perilRiCommRate")/100));
						}
						//end belle 04.24.2012
					}else {
						$("premiumAmt").focus();
						$("premiumAmt").value = "";
						showMessageBox("Premium Amount must not be greater than TSI amount.", imgMessage.ERROR);
					}
				}			
			} else {
				$("premiumAmt").focus();
				$("premiumAmt").value = "";
				showMessageBox("Entered Premium Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99 and must not be greater than TSI Amt.", imgMessage.ERROR);
			}
		} else {
			$("premiumAmt").focus();
			$("premiumAmt").value = "";
			showMessageBox("Entered Premium Amount is invalid. Valid value is from 0.00 to 9,999,999,999.99 and must not be greater than TSI Amt.", imgMessage.ERROR);
		}
	}catch(e){
		showErrorMessage("validateItemPerilPremAmt");
	}	
}