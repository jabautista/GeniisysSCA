//added by steven 09.11.2013
//for disabling button with class = "button2"
function disableButton2(buttonId) {
	try {
		$(buttonId).disable();
		$(buttonId).removeClassName("button2");
		$(buttonId).addClassName("disabledButton2");
	} catch (e){
		if(e.message == "$(buttonId) is null"){
			e.message = buttonId + " is null.";		
		}
		showErrorMessage("disableButton2", e);
	}
}