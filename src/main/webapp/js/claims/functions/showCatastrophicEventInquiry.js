function showCatastrophicEventInquiry(){
	new Ajax.Request(contextPath + "/GICLCatastrophicEventController", {
		method : "POST",
		parameters : {action 	: "showCatastrophicEventInquiry"},
        onCreate   : showNotice("Loading Catastrophic Event Inquiry, please wait..."),
        onComplete : function(response){
        	hideNotice();
        	try {
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch (e) {
				showErrorMessage("showCLMBatchRedistribution - onComplete : ", e);
			}
        }
	});
}
