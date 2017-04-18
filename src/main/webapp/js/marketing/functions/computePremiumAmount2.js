function computePremiumAmount2(perilObject){
	var premiumAmount = "";
	var prorateFlag = parseInt(objGIPIQuote.prorateFlag);
	var perilRate = formatToNineDecimal(perilObject.perilRate == "" ? "0" : perilObject.perilRate);
	var tsiAmt = perilObject.tsiAmount == "" ? "0" : perilObject.tsiAmount;
	switch (prorateFlag){
	case 1: 
		var diff = subtractDatesAddTwelve();
		premiumAmount = (parseInt($F("txtElapsedDays"))/diff) * ((parseFloat(perilRate)/100) * parseFloat(tsiAmt));
		break;
	case 2:
		premiumAmount = parseFloat(tsiAmt) * (parseFloat(perilRate)/100);
		break;
	case 3:
		premiumAmount = parseFloat(tsiAmt) * (parseFloat(perilRate)/100) * objGIPIQuote.shortRatePercent;
		break;
	default:
		premiumAmount = parseFloat(tsiAmt) * (parseFloat(perilRate)/100);
	}
	return premiumAmount;
}