function validateCTCNo2(ctcNo1,ctcNo2,id1,id2){
	var matched = false;
	new Ajax.Request(contextPath+"/GIISPrincipalSignatoryController",{
		method: "GET",
		evalScripts: true,
		asynchronous: false,
		parameters: {
			action: "validateCTCNo2",
			ctcNo1: ctcNo1,
			ctcNo2: ctcNo2,
			id1: id1,
			id2: id2
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