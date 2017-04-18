/*	Created by	: belle bebing 04.26.2011
 * 	Description	: computation of peril ann premium amount
*/
function computePerilAnnPremAmount(tsiAmt, perilRate){
	try {
		
		var perilRate 		= perilRate == null? "0" : perilRate ;
		var tsiAmt 			= unformatNumber(tsiAmt== null ? "0" : tsiAmt);
		var annPremAmt 		= null; 
		var provDiscount	= objUWParList.provPremPct == null ? "1" : objUWParList.provPremPct/100;
		var provPremTag		= objUWParList.provPremTag == null ? "N" : objUWParList.provPremTag;
				
		if (provPremTag == "N"){
			provDiscount = 1;
		}		
				
		if ((perilRate == null) || (tsiAmt == null)) {
			annPremAmt = null;
		} else {
			annPremAmt = (tsiAmt * perilRate/100) * provDiscount;
		}
		return annPremAmt;
	} catch (e) {
		showErrorMessage("computePerilAnnPremAmount", e);
	}
}