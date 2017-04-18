/**
 * To extract the message from sql exception, usable for raise_application_error in database procedures
 * @author andrew robes
 * @param errorMessage
 * @returns
 */
function extractSqlExceptionMessage(errorMessage){
	try {
		if(errorMessage.include("ORA")){
			var message = null;
			var causeLines = errorMessage.split("ORA");
			message = causeLines[1].substr(causeLines[1].indexOf(" "), causeLines[1].length);		
			return message;
		} else {
			return errorMessage;
		}
	} catch (e){
		showErrorMessage("extractSqlExceptionMessage", e);
	}
}