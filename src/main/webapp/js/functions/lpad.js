/*	Created by	: mark jm 07.22.2011
 * 	Description	: formats number by padding characters on the left side (oracle lpad-like)
 * 	Parameters	: value - the value/number to format
 * 				: length - the total length of the value/number to be formatted
 * 				: chr - the character that will be used for padding
 */
function lpad(value, length, chr){
	try{
		if(value == null || value == undefined){
			return "";
		}
		
		var diff = length - value.toString().length;
		var lpad = "";
	
		for(var i = 0; i < diff; i++){
			lpad = lpad.concat(chr);
		} 
	
		lpad = lpad.concat(value);
	
		return lpad;
	}catch(e){
		showMessageBox("lpad : " + e.message);
	}
}