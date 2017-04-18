/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	12.14.2010	mark jm			update the following amount in gipi_wpolbas
 * 	09.15.2011	mark jm			added recordStatus attribute  
 */
function parItemUpdateGipiWPolbas(){
	var tsi =  0;
	var prem = 0;
	var annTsi = 0;
	var annPrem = 0;
	
	for(var i=0, length=objGIPIWItem.length; i < length; i++){
		tsi = tsi + (nvl(objGIPIWItem[i].tsiAmt, 0) * nvl(objGIPIWItem[i].currencyRt, 1));
		prem = prem + (nvl(objGIPIWItem[i].premAmt, 0) * nvl(objGIPIWItem[i].currencyRt, 1));
		annTsi = annTsi + (nvl(objGIPIWItem[i].annTsiAmt, 0) * nvl(objGIPIWItem[i].currencyRt, 1));
		annPrem = annPrem + (nvl(objGIPIWItem[i].annPremAmt, 0) * nvl(objGIPIWItem[i].currencyRt, 1));
	}
	
	objGIPIWPolbas.tsiAmt = tsi;
	objGIPIWPolbas.premAmt = prem;
	objGIPIWPolbas.annTsiAmt = annTsi;
	objGIPIWPolbas.annPremAmt = annPrem;
	objGIPIWPolbas.recordStatus = 1;
}