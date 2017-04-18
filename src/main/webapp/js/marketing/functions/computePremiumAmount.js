function computePremiumAmount(){
	try {
		var premiumAmount = "";
		var prorateFlag = parseInt(objGIPIQuote.prorateFlag);
		var perilRate = formatToNineDecimal($F("txtPerilRate") == "" ? "0" : $F("txtPerilRate").replace(/,/g, ""));
		var tsiAmt = $F("txtTsiAmount") == "" ? "0" : $F("txtTsiAmount").replace(/,/g, "");
		switch (prorateFlag){
		case 1: 
			var diff = subtractDatesAddTwelve();
			// premiumAmount = formatCurrency((parseInt($F("days"))/diff) *
			// ((parseFloat(perilRate)/100) * parseFloat(tsiAmt)));
			premiumAmount = (parseInt($F("txtElapsedDays"))/diff) * ((parseFloat(perilRate)/100) * parseFloat(tsiAmt));
			break;
		case 2:
			premiumAmount = parseFloat(tsiAmt) * (parseFloat(perilRate)/100);
			break;
		case 3:
			premiumAmount = parseFloat(tsiAmt) * (parseFloat(perilRate)/100) * objGIPIQuote.shortRatePercent;
			// premiumAmount = formatCurrency(parseFloat(tsiAmt) *
			// (parseFloat(perilRate)/100) * parseFloat($F("shortRatePercent")));
			break;
		default:
			premiumAmount = parseFloat(tsiAmt) * (parseFloat(perilRate)/100);
		}
		$("txtPremiumAmount").value = formatCurrency(premiumAmount);
		return premiumAmount; 
	} catch(e){
		showErrorMessage("computePremiumAmount", e);
	}
}