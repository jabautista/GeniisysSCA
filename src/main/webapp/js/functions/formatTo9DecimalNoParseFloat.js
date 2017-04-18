/*	Created by	: mark jm 02.10.2011
 * 	Description	: formats a number with nine decimals (no parseFloat)
 * 	Parameters	: value - the value to format
 */
function formatTo9DecimalNoParseFloat(value){
	try{
		var returnValue = "";
		var amt;
		
		if(value == ""){
			returnValue = "";
		}else{
			amt = ((value).include(".") ? value : (value).concat(".00")).split(".");            
			returnValue = amt[0] + "." + rpad(amt[1], 9, "0");
		}
		
		return returnValue;
	}catch(e){
		showMessageBox("formatTo9DecimalNoParseFloat : " + e.message);
	}
}