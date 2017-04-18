/*	Created by	: mark jm 02.10.2011
 * 	Description	: formats number by padding characters on the right side (oracle rpad-like)
 * 	Parameters	: value - the value/number to format
 * 				: length - the total length of the value/number to be formatted
 * 				: chr - the character that will be used for padding
 */
function rpad(value, length, chr){
	try{
		if(value == null || value == undefined){
			return "";
		}
		
		var diff = length - value.toString().length;
		var rpad = "";
	
		for(var i = 0; i < diff; i++){
			rpad = rpad.concat(chr);
		} 
	
		rpad = value.concat(rpad);
	
		return rpad;
	}catch(e){
		showMessageBox("rpad : " + e.message);
	}
}