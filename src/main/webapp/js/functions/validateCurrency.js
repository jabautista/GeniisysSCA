//check if the value inputed is currency - meaning with decimal number
//parameters:
//fieldId: id of the element to be validated
//message: message to be displayed if validation fails
//messageType: to determine the message type
function validateCurrency(fieldId, message, messageType, min, max){
	var amount = $F(fieldId).replace(/,/g, "");
	
	for (var i=0; i<amount.length; i++) {
		if (isNaN(parseInt(amount.substring(i,i+1))) && amount.substring(i,i+1) != "."){
			if ("popup" == messageType) {
				showNotice(message);
			} else {
				showMessageBox(message, imgMessage.ERROR);
			}
			$(fieldId).value = formatCurrency("0");
			$(fieldId).focus();
		} else {
			if ("popup" == messageType) {
				hideNotice();
			}
		}
	}

	if (parseFloat(amount) < parseFloat(min) || parseFloat(amount) > parseFloat(max)) {
		if ("popup" == messageType) {
			showNotice(message);
		} else {
			showMessageBox(message, imgMessage.ERROR);
		}
		$(fieldId).value = formatCurrency("0");
		$(fieldId).focus();
		return false;
	} else {
		hideNotice();
	}
}