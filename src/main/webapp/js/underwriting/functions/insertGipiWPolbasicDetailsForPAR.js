function insertGipiWPolbasicDetailsForPAR(){
	new Ajax.Request(contextPath+"/GIPIPARListController?action=insertGipiWPolbasicDetailsForPAR", {
		method: "POST",
		//postBody: Form.serialize("uwParParametersForm"),
		evalScripts: true,
		asynchronous: true,
		parameters: {
			quoteId: 	$F("selectedQuoteId"),
			parId: 		$F("globalParId"),
			lineCd:		$F("selectedLineCd"),
			issCd: 		$F("selectedIssCd"),
			assdNo:		$F("assuredNo")
		},
		onComplete: function (response) {
			if (checkErrorOnResponse(response)) {
				var message = response.responseText;
				if ("" != message){
					showMessageBox(message, "info");
					hideNotice("");
				} else {
					hideNotice("SAVING SUCCESSFUL.");
					$("hasGIPIWPolBasDetails").value = "Y"; //-BRY
				}
			}
		}
	});
}