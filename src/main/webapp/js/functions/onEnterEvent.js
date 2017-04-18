//check event if "Enter"
function onEnterEvent(evt, func) {
	var keyCode = null;
	var myFunc = func;
	if( evt.which ) {
		keyCode = evt.which;
	} else if( evt.keyCode ) {
		keyCode = evt.keyCode;
	}
	if( 13 == keyCode ) {
		myFunc();
		return false;
	}
	return true;
}