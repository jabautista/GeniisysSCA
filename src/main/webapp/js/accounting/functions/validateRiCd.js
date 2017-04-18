// PROCEDURE validate_ri_cd
function validateRiCd() {
	var ok = true;
	if ($F("txtB140IssCd").blank() && $F("txtB140PremSeqNo").blank()
			&& $F("txtInstNo").blank()) {
		return false;
	} else {
		clearItemsAssociatedWithForeignKey();
		new Ajax.Request(
				contextPath + "/GIACPremDepositController?action=validateRiCd",
				{
					method : "GET",
					parameters : {
						b140PremSeqNo : $F("txtB140PremSeqNo"),
						instNo : parseInt($F("txtInstNo"), 10),
						assdNo : $F("txtAssdNo"),
						riCd : $F("txtRiCd"),
						riName : $F("txtRiName"),
						dspA150LineCd : $F("txtDspA150LineCd"),
						lineCd : $F("txtLineCd"),
						sublineCd : $F("txtSublineCd"),
						issCd : $F("txtIssCd"),
						issueYy : $F("txtIssueYy"),
						polSeqNo : $F("txtPolSeqNo"),
						renewNo : $F("txtRenewNo")
					},
					asynchronous : false,
					evalScripts : true,
					onCreate : function() {
						// showNotice("Validating RI Cd. Please wait...");
					},
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							// hideNotice("Done!");
							var resXML = response.responseXML;
							var message = "SUCCESS";

							$("txtAssdNo").value = resXML
									.getElementsByTagName("assdNo")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("assdNo")[0].childNodes[0].nodeValue;
							$("txtDspA150LineCd").value = resXML
									.getElementsByTagName("dspA150LineCd")[0].childNodes[0] == undefined ? ""
									: resXML
											.getElementsByTagName("dspA150LineCd")[0].childNodes[0].nodeValue;
							$("txtRiCd").value = resXML
									.getElementsByTagName("riCd")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("riCd")[0].childNodes[0].nodeValue;
							$("txtRiName").value = resXML
									.getElementsByTagName("riName")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("riName")[0].childNodes[0].nodeValue;
							$("txtLineCd").value = resXML
									.getElementsByTagName("lineCd")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("lineCd")[0].childNodes[0].nodeValue;
							$("txtSublineCd").value = resXML
									.getElementsByTagName("sublineCd")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("sublineCd")[0].childNodes[0].nodeValue;
							$("txtIssCd").value = resXML
									.getElementsByTagName("issCd")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("issCd")[0].childNodes[0].nodeValue;
							$("txtIssueYy").value = resXML
									.getElementsByTagName("issueYy")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("issueYy")[0].childNodes[0].nodeValue;
							$("txtPolSeqNo").value = resXML
									.getElementsByTagName("polSeqNo")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("polSeqNo")[0].childNodes[0].nodeValue;
							$("txtRenewNo").value = resXML
									.getElementsByTagName("renewNo")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("renewNo")[0].childNodes[0].nodeValue;
							message = resXML.getElementsByTagName("msg")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("msg")[0].childNodes[0].nodeValue;
							
							$("txtDrvRiName").value = $F("txtRiCd") + " - " + $F("txtRiName");	//shan 11.04.2013
							
							//marco - 12.09.2014
							$("txtParLineCd").value = resXML.getElementsByTagName("parLineCd")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("parLineCd")[0].childNodes[0].nodeValue;
							$("txtParIssCd").value = resXML.getElementsByTagName("parIssCd")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("parIssCd")[0].childNodes[0].nodeValue;
							$("txtParYy").value = resXML.getElementsByTagName("parYy")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("parYy")[0].childNodes[0].nodeValue;
							$("txtParSeqNo").value = resXML.getElementsByTagName("parSeqNo")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("parSeqNo")[0].childNodes[0].nodeValue;
							$("txtQuoteSeqNo").value = resXML.getElementsByTagName("quoteSeqNo")[0].childNodes[0] == undefined ? ""
									: resXML.getElementsByTagName("quoteSeqNo")[0].childNodes[0].nodeValue;
							premDepUpdateParNo();

							premDepUpdatePolicyNo();

							if (nvl(message, "SUCCESS") != "SUCCESS") {
								showMessageBox(message, imgMessage.ERROR);
							}
						} else {
							ok = false;
							showMessageBox(response.responseText,
									imgMessage.ERROR);
						}
					}
				});
	}

	return ok;
}