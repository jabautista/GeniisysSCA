/**
 * Recompute the peril rate whenever the premium amount value changes.
 * 
 */

function recomputePerilRateForPackQuote(){
	try {
		var perilRate = 0;
		var prorateFlag = parseInt(objCurrPackQuote.prorateFlag);
		var premiumAmount = parseFloat($F("txtPremiumAmount") == "" ? "0" :$F("txtPremiumAmount").replace(/,/g, ""));
		var tsiAmt = parseFloat($F("txtTsiAmount") == "" ? "0" : $F("txtTsiAmount").replace(/,/g, ""));
		
		switch (prorateFlag){
		case 1: 
			var diff = computeProratedDatesDiff(objCurrPackQuote.inceptDate);
			perilRate = premiumAmount / ((parseInt((objCurrPackQuote.elapsedDays)/diff) * 100)/(tsiAmt));
			break;
		case 2:
			perilRate = (premiumAmount/tsiAmt)*100;
			break;
		case 3:
			perilRate = 100(premiumAmount/(tsiAmt*parseFloat(objCurrPackQuote.shortRatePercent)));
			break;
		default:
			perilRate = (premiumAmount/tsiAmt)*100;
		}
		perilRate = formatToNineDecimal(perilRate);
		return perilRate; 
	} catch(e){
		showErrorMessage("recomputePerilRateForPackQuote", e);
	}
}