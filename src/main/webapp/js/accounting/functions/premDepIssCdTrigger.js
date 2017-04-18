// PROCEDURE iss_cd_trigger
function premDepIssCdTrigger() {
	if ($F("txtB140IssCd").blank() && $F("txtB140PremSeqNo").blank()
			&& $F("txtInstNo").blank()) {
		return false;
	} else {
		clearItemsAssociatedWithForeignKey();

		new Ajax.Request(
				contextPath
						+ "/GIACPremDepositController?action=executeIssCdTrigger",
				{
					method : "GET",
					parameters : {
						b140IssCd : $F("txtB140IssCd"),
						b140PremSeqNo : $F("txtB140PremSeqNo"),
						instNo : $F("txtInstNo").blank() ? "" : parseInt(
								$F("txtInstNo"), 10),
						lineCd : $F("txtLineCd"),
						sublineCd : $F("txtSublineCd"),
						issCd : $F("txtIssCd"),
						issueYy : $F("txtIssueYy"),
						polSeqNo : $F("txtPolSeqNo"),
						renewNo : $F("txtRenewNo")
					},
					asynchronous : true,
					evalScripts : true,
					onCreate : function() {
						// showNotice("Validating Issue Source. Please
						// wait...");
					},
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							// hideNotice("Done!");
							var resXML = response.responseXML;

							$("txtLineCd").value = resXML
									.getElementsByTagName("lineCd")[0].childNodes[0].nodeValue;
							$("txtSublineCd").value = resXML
									.getElementsByTagName("sublineCd")[0].childNodes[0].nodeValue;
							$("txtIssCd").value = resXML
									.getElementsByTagName("issCd")[0].childNodes[0].nodeValue;
							$("txtIssueYy").value = resXML
									.getElementsByTagName("issueYy")[0].childNodes[0].nodeValue;
							$("txtPolSeqNo").value = resXML
									.getElementsByTagName("polSeqNo")[0].childNodes[0].nodeValue;
							$("txtRenewNo").value = resXML
									.getElementsByTagName("renewNo")[0].childNodes[0].nodeValue;
						} else {
							showMessageBox(response.responseText,
									imgMessage.ERROR);
						}
					}
				});
	}
}