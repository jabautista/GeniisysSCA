function generatePdcId() {
	var dbPdcId = 0;

	new Ajax.Request(contextPath
			+ "/GIACAcknowledgmentReceiptsController?action=generatePdcId", {
		method : "GET",
		evalScripts : true,
		asynchronous : false,
		onSuccess : function(response) {
			if (checkErrorOnResponse(response)) {
				dbPdcId = response.responseText;
			}
		}
	});
	// above statement commented for now

	return dbPdcId;
}