// check if the value inputted is number
// parameters:
// fieldId: id of the element to be validated
// message: message to be displayed if valdiation fails
// messageType: to determine the message type
function isNumber(fieldId, message, messageType){
	var len = $F(fieldId).length;
	var val = $F(fieldId).replace(/,/g, "");
	for (var i=0; i< len; i++) {
		if (isNaN(parseFloat(val * 1))){
			if ("popup" == messageType){
				showNotice(message);
			} else {
				showMessageBox(message, imgMessage.ERROR);
			}
			$(fieldId).value = "";
			$(fieldId).focus();
			return false;
		} else{
			if ("popup" == messageType){
				hideNotice();
			}
			return true;
		}
	}
}