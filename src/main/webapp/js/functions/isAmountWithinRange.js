/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	11.14.2011	mark jm			check if amount is within the range
 */
function isAmountWithinRange(value, min, max){
	try{					
		if(compareAmounts(value.replace(/,/g, ""), min.replace(/,/g, "")) == 1 || compareAmounts(value.replace(/,/g, ""), max.replace(/,/g, "")) == -1){			
			return false;
		}else{			
			return true;
		}
	}catch(e){
		showErrorMessage("withinRange", e);
	}
}