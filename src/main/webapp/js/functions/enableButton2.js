//added by steven 09.11.2013
//for enabling button with class = "button2"
function enableButton2(buttonId) {
	$(buttonId).disabled = false;
	$(buttonId).removeClassName("disabledButton2");
	$(buttonId).addClassName("button2");
}