function getPolicyLinesForAssured(){
	new Ajax.Request(contextPath+"/GIISAssuredController?action=getLinesOfPolForAssd", {
		method: "POST",
		parameters: {
			assdNo: $F("assuredNo")
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response){
			if (checkErrorOnResponse(response)){
				objLines = eval(response.responseText);
			}
		}
	});

	return objLines;
}