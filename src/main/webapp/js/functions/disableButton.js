// disables a button, adds class 'disabledButton', removes class 'button'
//parameter:
//buttonId: id of the button to be enabled
function disableButton(buttonId) {
	try {
		$(buttonId).disable();
		$(buttonId).removeClassName("button");
		$(buttonId).addClassName("disabledButton");
	} catch (e){
		if(e.message == "$(buttonId) is null"){
			e.message = buttonId + " is null.";		
		}
		showErrorMessage("disableButton", e);
	}
}