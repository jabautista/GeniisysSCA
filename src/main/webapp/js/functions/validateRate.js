//check if the value inputed is currency - meaning with decimal number
//parameters:
//fieldId: id of the element to be validated
//message: message to be displayed if validation fails
//messageType: to determine the message type
function validateRate(fieldId) {
	var m = $(fieldId);
	
	if (formatToNineDecimal(m.value) > 100.000000000 || formatToNineDecimal(m.value) < 0.000000000) {
		showNotice("Invalid Currency Rate. Value should be from 0.000000001 to 100.000000000");
		m.value = "0";
	} else {
		hideNotice();
	}
	m.value = formatToNineDecimal(m.value == "" ? "0" : m.value);
}