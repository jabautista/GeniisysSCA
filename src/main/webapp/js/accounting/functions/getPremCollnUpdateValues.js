function getPremCollnUpdateValues(pdcPremRow) {
	var issCd = pdcPremRow.issCd;
	var premSeqNo = pdcPremRow.premSeqNo;
	var pdcPremUpdateObj;

	new Ajax.Request(
			contextPath
					+ "/GIACAcknowledgmentReceiptsController?action=fetchPdcPremUpdateValues",
			{
				method : "POST",
				parameters : {
					issCd : issCd,
					premSeqNo : premSeqNo
				},
				evalScripts : true,
				asynchronous : false,
				onCreate : function() {

				},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						pdcPremUpdateObj = JSON.parse(response.responseText);
					}
				}
			});

	return pdcPremUpdateObj;
}