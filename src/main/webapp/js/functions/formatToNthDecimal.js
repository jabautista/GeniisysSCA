//format percent rates up to n'th decimal places (emman 12.28.2010)
//mark jm 10.17.2011 validate first the parameter before using any function
function formatToNthDecimal(num, n)	{
	/*num = num.toString().replace(/\$|\,/g,'');
	if (isNaN(num) || num.empty() || num == undefined) {
		return "";
	}
	return parseFloat(num).toFixed(n);*/
	try{		
		if (num == null | num == undefined | isNaN(num)) {
			return "";
		}else if(num.toString() == ""){
			return "";
		}
		
		num = num.toString().replace(/\$|\,/g,'');
		
		var returnValue = "";
		var amt;
		
		if(num == ""){
			returnValue = "";
		}else{
			amt = ((num).include(".") ? num : (num).concat(".00")).split(".");
			
			// mark jm 10.07.2011 added condition for decimal digits
			if(n > amt[1].length){				
				returnValue = amt[0] + "." + rpad(amt[1], n, "0");
			}else{				
				returnValue = amt[0] + "." + amt[1].substring(0, n);
			}
			
		}
		
		return returnValue;
	}catch(e){
		showMessageBox("formatToNthDecimal : " + e.message);
	}
}