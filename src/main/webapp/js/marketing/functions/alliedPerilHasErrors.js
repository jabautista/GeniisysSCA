/**
 * Check allied peril for the ff conditions 
 * - allied peril having dependent basic perils -- the basic peril must be added in list!
 * - tsi amount 
 * #validation #peril
 * ALLIED PERILS
 */
function alliedPerilHasErrors(perilObj){
	if(perilObj.perilType=="A"){
		var aPerilFromList = null;
		if(perilObj.basicPerilCd!=""){
			// find highest tsi?
			for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){ // look for its basic peril
				aPerilFromList = objGIPIQuoteItemPerilSummaryList[i];
				if(aPerilFromList.perilType == perilObj.basicPerilCd && 
						aPerilFromList.tsiAmount < perilObj.tsiAmount){
					return true;
				}
				return false;
			}
		}else{
			var found = false;
			// find tsi of basic peril cd
			for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
				aPerilFromList = objGIPIQuoteItemPerilSummaryList[i];
				if(aPerilFromList.perilType == "B"){
					if(aPerilFromList.perilCd == perilObj.basicPerilCd){
						// compare tsi amounts
						found = true;
					}
				}
			}
			return !found; // negate the answer
		}
	}else{
		return false;
	}
}