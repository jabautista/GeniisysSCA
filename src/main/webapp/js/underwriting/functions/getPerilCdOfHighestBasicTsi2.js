/*	Created by	: joanne 01.23.2014
 * 	Description	: validation for renewal perils
 */
function getPerilCdOfHighestBasicTsi2(itemNo){
	try{		
		var highestBasicTsiAmt = getHighestBasicTsiAmt3(itemNo);
	    var perilCd = null;
		
		var objArrFiltered = objGIEXItmPeril.filter(function(obj){	return obj.itemNo == itemNo && obj.dspPerilType == "B";	});
		
		if(objArrFiltered.length > 0){
			for (var i=0; i<objArrFiltered.length; i++){
				if (objArrFiltered[i].tsiAmt == highestBasicTsiAmt){
					perilCd = objArrFiltered[i].perilCd;
				}
			}
		}
		
		return perilCd;
	}catch(e){
		showErrorMessage("getPerilCdOfHighestBasicTsi2", e);
	}	
}