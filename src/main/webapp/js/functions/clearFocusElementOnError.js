//BJGA 01.25.2011
function clearFocusElementOnError(elementId, errorMessage){
	$(elementId).value = "";
	showWaitingMessageBox(errorMessage, imgMessage.ERROR, 
		function(){
			$(elementId).focus();
		}
	);
}