// enables a button, adds class 'button', removes class 'disableButton'
// parameter:
// buttonId: id of the button to be disabled
function enableButton(buttonId) {
	$(buttonId).disabled = false;
	$(buttonId).removeClassName("disabledButton");
	$(buttonId).addClassName("button");
}