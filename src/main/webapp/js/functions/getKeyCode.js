// get event keyCode
function getKeyCode(evt, elem){
	obj = elem;
	var keyCode;
	if ("which" in evt) {// NN4 & FF &amp; Opera
		keyCode=evt.which;
	} else if ("keyCode" in evt) {// Safari & IE4+
	    keyCode=evt.keyCode;
	} else if ("keyCode" in window.event) {// IE4+
	    keyCode=window.event.keyCode;
	} else if ("which" in window.event) {
	    keyCode=evt.which;
	} else  {    
		alert("the browser don't support");  
	}
	return keyCode;
}