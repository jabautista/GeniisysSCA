/**
 * Compute peril premium amount based on the selected package quote.
 * @return premiumAmount - the computed premium amount value
 */

function computePremiumAmountForPackQuote(){
	try {
		var premiumAmount = 0;
		var prorateFlag = parseInt(objCurrPackQuote.prorateFlag);
		var perilRate = formatToNineDecimal($F("txtPerilRate") == "" ? "0" : $F("txtPerilRate").replace(/,/g, ""));
		var tsiAmt = $F("txtTsiAmount") == "" ? "0" : $F("txtTsiAmount").replace(/,/g, "");
		
		switch (prorateFlag){
		case 1: 
			var diff = computeProratedDatesDiff(objCurrPackQuote.inceptDate);
			premiumAmount = (parseInt(objCurrPackQuote.elapsedDays)/diff) * ((parseFloat(perilRate)/100) * parseFloat(tsiAmt));
			break;
		case 2:
			premiumAmount = parseFloat(tsiAmt) * (parseFloat(perilRate)/100);
			break;
		case 3:
			premiumAmount = parseFloat(tsiAmt) * (parseFloat(perilRate)/100) * parseFloat(objCurrPackQuote.shortRatePercent);
			break;
		default:
			premiumAmount = parseFloat(tsiAmt) * (parseFloat(perilRate)/100);
		}
		premiumAmount = formatCurrency(premiumAmount);
		return premiumAmount; 
	} catch(e){
		showErrorMessage("computePremiumAmountForPackQuote", e);
	}
}