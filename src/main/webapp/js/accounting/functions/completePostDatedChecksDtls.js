function completePostDatedChecksDtls(issCd, premSeqNo) {
	new Ajax.Request(
			contextPath
					+ "/GIACAcknowledgmentReceiptsController?action=getPdcPostQueryDtls",
			{
				method : "POST",
				parameters : {
					issCd : issCd,
					premSeqNo : premSeqNo
				},
				evalScripts : true,
				asynchronous : false,
				onCreate : function() {
					// showNotice("Loading details. Please wait...");
				},
				onSuccess : function(response) {
					if (checkErrorOnResponse(response)) {
						postDatedChecksDtlsObj = JSON
								.parse(response.responseText);
						// hideNotice("");
					}
				}
			});
}