/*	Created by	: robert 10.03.2013
 */
function getPerilCdOfHighestBasicTsi(itemNo){
	try{		
		var highestBasicTsiAmt = getHighestBasicTsiAmt2(itemNo);
	    var perilCd = null;
		
		var objArrFiltered = objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == itemNo && obj.perilType == "B";	});
		
		if(objArrFiltered.length > 0){
			for (var i=0; i<objArrFiltered.length; i++){
				if (objArrFiltered[i].tsiAmt == highestBasicTsiAmt){
					perilCd = objArrFiltered[i].perilCd;
				}
			}
		}
		
		return perilCd;
	}catch(e){
		showErrorMessage("getHighestBasicTsiAmt2", e);
	}	
}