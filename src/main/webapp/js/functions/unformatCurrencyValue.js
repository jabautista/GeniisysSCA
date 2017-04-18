/*	Created by	: mark jm 04.06.07 (@UCPBGen) 
 * 	Description	: another version of unformatCurrency 
 */
function unformatCurrencyValue(value) {
	try{
		value = nvl(value, ""); // added by: Nica to handle null value
		var unformattedValue = "";	
		if (value.replace(/,/g, "") != "" && !isNaN(parseFloat(value.replace(/,/g, "")))){
			unformattedValue = parseFloat(value.replace(/,/g, ""));
		}
		return unformattedValue;	
	}catch(e){
		showErrorMessage("unformatCurrencyValue", e);
	}	
}