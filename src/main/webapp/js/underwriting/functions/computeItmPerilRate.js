/*	Created by	: belle bebing 04.24.2012
 * 	Description	: computation of peril rate 
*/
function computeItmPerilRate(){ 
	try {	
		var perilRate 		= null;
		var premAmt 		= unformatNumber($F("premiumAmt") == null? "0" : $F("premiumAmt")) ;		
		var tsiAmt 			= unformatNumber($F("perilTsiAmt")== null ? "0" : $F("perilTsiAmt"));
		var shorRate		= ($("shortRatePercent") == null ? nvl(objGIPIWPolbas.shortRtPercent ,0) : $F("shortRatePercent"))
		var prorateFlag		= objUWParList.prorateFlag;
		var startDate 		= dateFormat($F("globalEffDate"), "mm-dd-yyyy");
		var endDate			= dateFormat($F("globalExpiryDate"), "mm-dd-yyyy");

		if ((premAmt == null) || (tsiAmt == null)) {
			perilRate = null;
		} else {
			if (prorateFlag == 1){
				var prorate = computeNoOfDays(startDate, endDate, nvl(objUWParList.compSw, objGIPIWPolbas.compSw))
						   /checkDuration(/*nvl(objUWParList.effDate, objGIPIWPolbas.effDate)*/$F("globalEffDate"),$F("globalExpiryDate") /*nvl(objUWParList.expiryDate, objGIPIWPolbas.expiryDate)*/);
				perilRate = formatToNineDecimal(((premAmt/tsiAmt)/prorate) * 100);
			}else if (prorateFlag == 2){
				perilRate = formatToNineDecimal((premAmt/tsiAmt) * 100);
			}else {
				perilRate = formatToNineDecimal((premAmt/(tsiAmt * shorRate)) * 100);
			}
		}
		return perilRate; 
	}catch(e) {
			showErrorMessage("computeItmPerilRate", e);
	}
}