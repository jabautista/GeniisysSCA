var annTsiAmountCopy 	= 0;
var annPremiumAmountCopy = 0;
var hidTsiAmount		= null;
var hidAnnTsiAmount	 	= null;
var hidPremiumAmount	= null;
var hidAnnPremiumAmount	= null;

/*function computeItmPerilRate() {
	$("premiumAmt").value = formatCurrency(parseFloat($("premiumAmt").value));
	var premiumAmount = parseFloat($F("premiumAmt").replace(/,/g, ""));
	var prorateFlag = parseInt($F("prorateFlag"));
	var perilRate = formatToNineDecimal($F("perilRate") == "" ? "0" : $F("perilRate").replace(/,/g, ""));
	var tsiAmt = parseFloat($F("perilTsiAmt") == "" ? "0" : $F("perilTsiAmt").replace(/,/g, ""));
		switch (prorateFlag) {
			case 1: 
				var diff = subtractDatesAddTwelve();
				break;
			case 2:
				perilRate = formatToNineDecimal((premiumAmount/tsiAmt)*100);
				break;
			case 3:
				perilRate = formatToNineDecimal((premiumAmount * 100)/(tsiAmt*parseFloat($F("shortRtPercent"))));
				break;
			default:
				perilRate = formatToNineDecimal((premiumAmount/tsiAmt)*100);
		}
		$("perilRate").value = formatToNineDecimal(perilRate);
}*/ //belle 04.24.2012 replaced by codes below

/*function validateDeletePeril(objArray){
	var itemNo = $("txtB480ItemNo").value; 
	var perilCd = $("txtB490PerilCd").value;
	
	for (var i=0; i<objArray.length; i++){
		if(itemNo == objArray[i].itemNo && perilCd == objArray[i].dspBascPerlCd  && objArray[i].recordStatus != -1){
			showMessageBox("The peril '"+objGIEXItmPeril[i].dspPerilName+"' must be deleted first.", imgMessage.ERROR);
			return false;
		}
	}
	return true;
}*/