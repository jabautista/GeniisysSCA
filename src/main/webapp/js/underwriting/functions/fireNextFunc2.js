function fireNextFunc2(){
	new Ajax.Request(contextPath+"/GIPIPARListController?action=checkIfAssdIsSelected",{
		method:"GET",
		asynchronous: true,
		evalScripts: true,
		onComplete: function (response) {
			if (checkErrorOnResponse(response)) {
				if (response.responseText.include("Y")) {
					objSelectedQuote.assdNo = $("assuredNo").value;
					objSelectedQuote.assdName = $("assuredName").value;
					updateQuoteFromPar2(objSelectedQuote);
				}
			}
		}
	});
	assuredListingFromPAR = 0;
}