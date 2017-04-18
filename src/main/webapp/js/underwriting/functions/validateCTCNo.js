function validateCTCNo(ctcNo){
	var matched = false;
	new Ajax.Request(contextPath+"/GIISPrincipalSignatoryController",{
		method: "GET",
		evalScripts: true,
		asynchronous: false,
		parameters: {
			action: "validateCTCNo",
			ctcNo: ctcNo
		},onCreate: function(){
			showNotice("Validating please wait..");
		},onComplete: function(response){
			hideNotice();
			if(checkErrorOnResponse(response)){
				if(response.responseText == "1"){
					matched= true;
				}	
			}
		}
	});
	return matched;
}