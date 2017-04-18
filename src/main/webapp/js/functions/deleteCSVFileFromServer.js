function deleteCSVFileFromServer(filename){
	new Ajax.Request(contextPath+"/GIISUserController?action=deleteCSVFileFromServer", {
		method: "POST",
		parameters: {
			filename: filename
		},
		asynchronous: false,
		onCreate: showNotice("Please wait..."),
		onComplete: function (response){
			hideNotice();
			checkErrorOnResponse(response);
		}
	});
}