/**
* Retrieve details of item to be endorsed
* @author d.alcantara
* @date 07.21.2011
* @param addFlag - value = 0 for add, -1 for delete
*/
function setCoverageAmounts(addFlag, obj) {
	try {
		//
		var sumAnnTsiAmt = 0;
		var sumAnnPremAmt = 0;
		var amtCovered = 0;
		if(addFlag < 0) {
			sumAnnTsiAmt = $F("gAnnTsiAmt") == "" ? 0 : unformatCurrencyValue($F("gAnnTsiAmt"));
			sumAnnPremAmt = $F("gAnnPremAmt") == "" ? 0 : unformatCurrencyValue($F("gAnnPremAmt"));
			amtCovered = $F("amountCovered") == "" ? 0 : unformatCurrencyValue($F("amountCovered"));
		}
		
		for(var i=0; i<objGIPIWItmperlGrouped.length; i++) {
			if(objGIPIWItmperlGrouped[i].groupedItemNo == removeLeadingZero($F("groupedItemNo"))
					&& objGIPIWItmperlGrouped[i].itemNo == $F("itemNo")) {
				if(objGIPIWItmperlGrouped[i].recordStatus == -1 && addFlag == -1) {
					// d.alcantara, 8-14-2012, removed unformatCurrencyValue
					sumAnnTsiAmt -= parseFloat(objGIPIWItmperlGrouped[i].annTsiAmt);
					sumAnnPremAmt -= parseFloat(objGIPIWItmperlGrouped[i].annPremAmt);
					amtCovered -= parseFloat(objGIPIWItmperlGrouped[i].tsiAmt);
				} else if(nvl(objGIPIWItmperlGrouped[i].recordStatus, null) != -1 && addFlag != -1){
					// d.alcantara, 8-14-2012, removed unformatCurrencyValue
					sumAnnTsiAmt += parseFloat(objGIPIWItmperlGrouped[i].annTsiAmt);
					sumAnnPremAmt += parseFloat(objGIPIWItmperlGrouped[i].annPremAmt);
					amtCovered += parseFloat(objGIPIWItmperlGrouped[i].tsiAmt);
					
				} /* else if(obj != null && obj.perilCd == objGIPIWItmperlGrouped[i].perilCd) {
					if(objGIPIWItmperlGrouped[i].recordStatus == 1) {
						sumAnnTsiAmt += unformatCurrencyValue(objGIPIWItmperlGrouped[i].annTsiAmt);
						sumAnnPremAmt += unformatCurrencyValue(objGIPIWItmperlGrouped[i].annPremAmt);
						amtCovered += unformatCurrencyValue(objGIPIWItmperlGrouped[i].tsiAmt);
					} else {
						sumAnnTsiAmt -= unformatCurrencyValue(objGIPIWItmperlGrouped[i].annTsiAmt);
						sumAnnPremAmt -= unformatCurrencyValue(objGIPIWItmperlGrouped[i].annPremAmt);
						amtCovered -= unformatCurrencyValue(objGIPIWItmperlGrouped[i].tsiAmt);
					}
				}*/
			}
		}
		var newObj = null;
		$("amountCovered").value = formatCurrency(amtCovered);
		$("gAnnTsiAmt").value = formatCurrency(sumAnnTsiAmt);
		$("gAnnPremAmt").value = formatCurrency(sumAnnPremAmt);
		for(var i=0; i<objGIPIWGroupedItems.length; i++) {
			if(parseInt(objGIPIWGroupedItems[i].groupedItemNo) == parseInt($F("groupedItemNo"))
					&& parseInt(objGIPIWGroupedItems[i].itemNo) == parseInt($F("itemNo"))) {
				newObj = objGIPIWGroupedItems[i];
				newObj.amountCovered = amtCovered;
				newObj.annTsiAmt = sumAnnTsiAmt;
				newObj.annPremAmt = sumAnnPremAmt;
				newObj.dateOfBirth = nvl($F("dateOfBirth"), null);
				newObj.fromDate = nvl($F("grpFromDate"), null);
				newObj.toDate = nvl($F("grpToDate"), null);
				newObj.recordStatus = 1;
				objGIPIWGroupedItems.splice(i, 1);
				objGIPIWGroupedItems.push(newObj);
			}
		}
	} catch(e) {
		showErrorMessage("setCoverageAmounts", e);
	}
}