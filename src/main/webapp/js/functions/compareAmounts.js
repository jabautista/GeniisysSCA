/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	11.14.2011	mark jm			compare amounts (returns -1 [amt1 > amt2], 1 [amt1 < amt2], 0 [amt1 == amt2])
 */
function compareAmounts(amt1, amt2){
	try{
		var result = 0;
		var amount1;
		var amount2;		
		
		amt1 = amt1 != "" && amt1 != undefined && amt1 != null ? amt1 : "0.00";
		amt2 = amt2 != "" && amt2 != undefined && amt2 != null ? amt2 : "0.00";			
		
		if(amt1.toString().include("-") && !(amt2.toString().include("-"))){				
			result = 1;
		}else if(!(amt1.toString().include("-")) && amt2.toString().include("-")){				
			result = -1;
		}else{
			amt1 = amt1.toString().include(".") ? amt1 : (amt1 == "0" ? "0.00" : amt1+".00");
			amt2 = amt2.toString().include(".") ? amt2 : (amt2 == "0" ? "0.00" : amt2+".00");
			
			amount1 = amt1.split(".");
			amount2 = amt2.split(".");
			
			if(parseInt(amount1[0], 10) < parseInt(amount2[0], 10)){					
				result = 1;
			}else if(parseInt(amount1[0], 10) > parseInt(amount2[0], 10)){					
				result = -1;
			}else if(parseInt(amount1[0], 10) == parseInt(amount2[0], 10)){
				var charLength = amount1[1].length > amount2[1].length ? amount1[1].length : amount2[1].length;
				var deci1 = rpad(amount1, charLength, "0");
				var deci2 = rpad(amount2, charLength, "0");
				
				if(parseInt(deci1, 10) < parseInt(deci2, 10)){						
					result = 1;
				}else if(parseInt(deci1, 10) > parseInt(deci2, 10)){						
					result = -1;
				}else if(parseInt(amount1[1],10) > parseInt(amount2[1],10)){ // added for proper comparing of decimal places - irwin
					result = -1;
				}else{						
					result = 0;
				}
			}
		}		
		
		return result;
	}catch(e){
		showErrorMessage("compareAmounts", e);
	}
}