/*	Created by	: belle bebing 04.26.2011
 * 	Description	: computation of peril premium amount
*/
function computePerilPremAmount(prorateFlag, tsiAmount, perilRt){
	try {		
		var perilRate 		= perilRt == null? "0" : perilRt ;		
		var tsiAmt 			= unformatNumber(tsiAmount== null ? "0" : tsiAmount);
		var premAmt 		= null;		
		var provDiscount	= nvl(objUWParList.provPremPct, objGIPIWPolbas.provPremPct) == null ? "1" : nvl(objUWParList.provPremPct, objGIPIWPolbas.provPremPct) /100;
		var provPremTag		= nvl(objUWParList.provPremTag, objGIPIWPolbas.provPremTag) == null ? "N" : nvl(objUWParList.provPremTag, objGIPIWPolbas.provPremTag);
		/*var prorate			= computeNoOfDays(nvl(objUWParList.effDate, objGIPIWPolbas.effDate),
								nvl(objUWParList.expiryDate, objGIPIWPolbas.expiryDate),
								nvl(objUWParList.compSw, objGIPIWPolbas.compSw)) / 
								checkDuration(nvl(objUWParList.effDate, objGIPIWPolbas.effDate), nvl(objUWParList.expiryDate, objGIPIWPolbas.expiryDate));*/ 
		//belle 04.24.2012 replaced by codes below
		var startDate 		= dateFormat($F("globalEffDate"), "mm-dd-yyyy");
		var endDate			= dateFormat($F("globalExpiryDate"), "mm-dd-yyyy");
		
		if (provPremTag == "N"){
			provDiscount = 1;
		}
		if ((perilRate == null) || (tsiAmt == null)) {
			premAmt = null;
		} else {
			if (prorateFlag == 1){
				var prorate = computeNoOfDays(startDate, endDate, nvl(objUWParList.compSw, objGIPIWPolbas.compSw))
				   /checkDuration(/*nvl(objUWParList.effDate, objGIPIWPolbas.effDate)*/$F("globalEffDate"), /*nvl(objUWParList.expiryDate, objGIPIWPolbas.expiryDate)*/$F("globalExpiryDate"));
		
				premAmt = (tsiAmt * perilRate/100) * provDiscount * prorate;
			}else if (prorateFlag == 2){
				premAmt = (tsiAmt * perilRate/100) * provDiscount;
			}else {
				premAmt = ((tsiAmt * perilRate * ($("shortRatePercent") == null ? nvl(objGIPIWPolbas.shortRtPercent ,0) : $F("shortRatePercent")) )/10000) / provDiscount; 
			}
		}
		
		//belle 10.05.2011 added condition to consider exponential nos.
		if (premAmt.toString().include("e")){
			premAmt = formatCurrency(cnvrtPremAmt(premAmt));
		}else{
			premAmt = formatCurrency(premAmt);
		}
		
		return premAmt;
	} catch (e) {
		showErrorMessage("computePerilPremAmount", e);
	}
}