/**
 * Shows the custom sql exception message thrown from database script validations
 * @author andrew robes
 * @date 03.23.2012
 * @params response - ajax response
 */
function checkCustomErrorOnResponse(response, func) {
	if (response.responseText.include("Geniisys Exception")){
		var message = response.responseText.split("#"); 
		showMessageBox(message[2], message[1]);
		if(func != null) func();
		return false;
	} else {
		return true;
	}
}