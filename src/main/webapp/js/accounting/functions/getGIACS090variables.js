function getGIACS090variables() {
	new Ajax.Request(
			contextPath
					+ "/GIACAcknowledgmentReceiptsController?action=getGiacs090Variables",
			{
				method : "GET",
				asynchronous : true,
				evalScripts : true,
				onSuccess : function(response) {
					if (checkErrorOnResponse(response)) {
						giacs090variables = JSON.parse(response.responseText);
					}
				}
			});
}