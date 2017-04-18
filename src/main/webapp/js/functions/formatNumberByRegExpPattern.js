/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	11.28.2011	mark jm			format value based on the reg exp pattern of the element 
 */
function formatNumberByRegExpPattern(m){
	try{
		if(m.value == undefined || m.value == null || m.value == ""){
			return "";
		}
		
		var whle = parseInt((m.value.replace(/,/g, "")).match(/(?:\d+)/)[0].length, 10);
		var dcml = parseInt(removeLeadingZero(m.getAttribute("regExpPatt").match(/[0-9]+/).toString().substr(2,2)), 10);
		var val = "";						
		
		val = removeLeadingZero((m.value).replace(/,/g, ""));
		val = val + (val.indexOf(".") == -1 ? "." : "");
		val = rpad(val, whle + dcml + 1, "0");
		
		return val;
	}catch(e){
		showErrorMessage("formatNumberByRegExpPattern", e);
	}
}