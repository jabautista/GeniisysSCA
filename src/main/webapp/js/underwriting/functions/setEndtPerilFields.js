/*	Created by	: andrew robes
 * 	Move by		: mark jm
 * 	From		: endtPerilInformation page
 */
function setEndtPerilFields(peril){
	try {
		$("inputPremiumRate").value		= (peril == null ? formatToNineDecimal("0") : formatToNineDecimal(peril.premRt));
		$("inputPremiumRate").setAttribute("premRt", (peril == null ? 0 : formatToNineDecimal(peril.premRt)));
		$("inputTsiAmt").value 			= hidTsiAmount 	   	  = (peril == null ? formatCurrency("0") : formatCurrency(peril.tsiAmt));
		$("inputTsiAmt").setAttribute("tsiAmt", (peril == null ? "0" : peril.tsiAmt));		
		$("inputAnnTsiAmt").value		= hidAnnTsiAmount  	  = (peril == null ? formatCurrency("0") : formatCurrency(peril.annTsiAmt));
		$("inputPremiumAmt").value 		= hidPremiumAmount    = (peril == null ? formatCurrency("0") : formatCurrency(peril.premAmt));
		$("inputPremiumAmt").setAttribute("premAmt", (peril == null ? "0" : peril.premAmt));
		$("inputAnnPremiumAmt").value 	= hidAnnPremiumAmount = (peril == null ? formatCurrency("0") : formatCurrency(peril.annPremAmt));		
		$("inputRiCommRate").value 		= (peril == null ? formatToNineDecimal("0") : formatToNineDecimal(peril.riCommRate));
		$("inputRiCommRate").setAttribute("riCommRate", (peril == null ? formatCurrency("0") : peril.riCommRate));
		$("inputRiCommAmt").value		= (peril == null ? formatCurrency("0") : formatCurrency(peril.riCommAmt));
		$("inputRiCommAmt").setAttribute("riCommAmt", (peril == null ? formatCurrency("0") : formatCurrency(peril.riCommAmt)));
		$("inputCompRem").value 		= (peril == null ? "" : unescapeHTML2(peril.compRem));
		$("inputNoOfDays").value		= peril == null ? "" : peril.noOfDays;
		$("inputBaseAmt").value			= peril == null ? formatCurrency("0") : formatCurrency(peril.baseAmt);
		$("inputAnnTsiAmt").setAttribute("endtAnnTsiAmt", (peril == null ? "0.00" : peril.endtAnnTsiAmt)); // holds the value of the retrieved ann tsi amt from previous policies
		$("inputAnnPremiumAmt").setAttribute("endtAnnPremAmt", (peril == null ? "0.00" : peril.endtAnnPremAmt)); // holds the value of the retrieved ann premium amt from previous policies
		$("inputAnnPremiumAmt").setAttribute("oldBaseAnnPremAmt", (peril == null ? "0.00" : peril.baseAnnPremAmt));
		$("inputAnnPremiumAmt").setAttribute("baseAnnPremAmt", (peril == null ? "0.00" : peril.baseAnnPremAmt));
		$("hidPerilRecFlag").value		= peril == null ? "" : peril.recFlag;
		
		// the following will be used to retain the last accepted valid value of the fields when an exception occurred in the newly entered value
		$("inputTsiAmt").setAttribute("oldTsiAmt", (peril == null ? "0" : peril.tsiAmt));
		$("inputPremiumAmt").setAttribute("oldPremAmt", (peril == null ? "0" : peril.premAmt));
		$("inputAnnTsiAmt").setAttribute("oldAnnTsiAmt", (peril == null ? "0.00" : peril.annTsiAmt)); 
		$("inputAnnPremiumAmt").setAttribute("oldAnnPremAmt", (peril == null ? "0.00" : peril.annPremAmt));
	} catch (e) {
		showErrorMessage("setEndtPerilFields", e);
	}
}