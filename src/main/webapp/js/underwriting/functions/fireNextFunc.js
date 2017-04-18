function fireNextFunc(){
	new Ajax.Request(contextPath+"/GIPIPARListController?action=checkIfAssdIsSelected",{
		method:"GET",
		asynchronous: true,
		evalScripts: true,
		onComplete: function (response) {
			if (checkErrorOnResponse(response)) {
				if (response.responseText.include("Y")) {
					getAssuredValues();
				}
			}
		}
	});
	assuredListingFromPAR = 0;
}