function showTransactionStatus() {
	new Ajax.Request(contextPath + "/GIACInquiryController", {
	    parameters : {action : "showTransactionStatus"},
	    onCreate: showNotice("Getting Transaction Status, please wait..."),
		onComplete : function(response){
			hideNotice();
			try {
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showTransactionStatus - onComplete : ", e);
			}								
		} 
	});
}