/*	Created by	: joanne 01.21.2014
 * 	Description	: validation for renewal perils
 */
function getHighestBasicTsiAmt3(itemNo){
	try{
		var highestBasicTsiAmt = 0;
		
		var objArrFiltered = objGIEXItmPeril.filter(function(obj){	return obj.itemNo == itemNo && obj.dspPerilType == "B";	});

		if(objArrFiltered.length > 0){
			perilExistsForCurrentItem = true;
			highestBasicTsiAmt = parseFloat(objArrFiltered.max(function(obj) {
				return parseFloat(obj.tsiAmt);	 
			}));
		}		
		
		return highestBasicTsiAmt;
	}catch(e){
		showErrorMessage("getHighestBasicTsiAmt3", e);
	}	
}