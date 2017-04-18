/**
 * Display Additional Information depending on its lineCd
 * @param obj
 */
function showAdditionalInfoPage(obj){
	try{
		var lineCd = getLineCdMarketing();
		
		if(lineCd == "FI"){
			supplyQuoteFIAdditional(obj);
		}else if(lineCd == "AC" || lineCd == "PA"){
			supplyQuoteAHAdditional(obj);
		}else if(lineCd == "AV"){
			supplyAVAdditional(obj);
		}else if(lineCd == "MN"){
			supplyQuoteMNAdditional(obj);
		}else if(lineCd == "EN"){
			supplyQuoteENAdditional(obj);
		}else if(lineCd == "CA"){
			supplyQuoteCAAdditional(obj);
		}else if(lineCd == "MC"){
			supplyQuoteMCAdditional(obj);
		}else if(lineCd == "MH"){
			supplyQuoteMHAdditional(obj);
		}
	}catch (e){
		showErrorMessage("showAdditionalInfoPage", e);
	}
}