/*	Created by	: joanne 01.21.2014
 * 	Description	: validation for renewal perils
 */
function getHighestAlliedTsiAmt3(itemNo){
	try{
		var highestAlliedTsiAmt = 0;
		
		var objArrFiltered = objGIEXItmPeril.filter(function(obj){	return obj.itemNo == itemNo && obj.dspPerilType == "A";	});

		if(objArrFiltered.length > 0){			
			perilExistsForCurrentItem = true;
			highestAlliedTsiAmt = parseFloat(objArrFiltered.max(function(obj) {
				return parseFloat(obj.tsiAmt); 
			}));
		}		
		
		return highestAlliedTsiAmt;
	}catch(e){
		showErrorMessage("getHighestAlliedTsiAmt3", e);
	}	
}