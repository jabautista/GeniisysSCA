// andrew 07.11.2010
// This function programatically fires an event of the given element
// Parameters: element - element to which the event will be triggered.
// 			   event - name of event to be triggered.
function fireEvent(element, event){
	if (document.createEventObject){
	// dispatch for IE
		var evt = document.createEventObject();
		return element.fireEvent('on'+event,evt);
	} else{
	// dispatch for firefox + others
		var evt = document.createEvent("HTMLEvents");
		evt.initEvent(event, true, true); // event type,bubbling,cancelable
		return !element.dispatchEvent(evt);
	}
}