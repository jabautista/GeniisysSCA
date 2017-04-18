/*	Created by	: joanne 01.28.2014
 * 	Description	: validation for renewal perils
 */
function getPerilCdOfHighestAlliedTsi(itemNo){
	try{		
		var highestAlliedTsiAmt = getHighestAlliedTsiAmt3(itemNo);
	    var perilCd = null;
		
		var objArrFiltered = objGIEXItmPeril.filter(function(obj){	return obj.itemNo == itemNo && obj.dspPerilType == "A";	});
		
		if(objArrFiltered.length > 0){
			for (var i=0; i<objArrFiltered.length; i++){
				if (objArrFiltered[i].tsiAmt == highestAlliedTsiAmt){
					perilCd = objArrFiltered[i].perilCd;
				}
			}
		}
		
		return perilCd;
	}catch(e){
		showErrorMessage("getPerilCdOfHighestAlliedTsi", e);
	}	
}