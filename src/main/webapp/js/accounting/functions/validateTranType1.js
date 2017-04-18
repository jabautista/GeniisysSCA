// PROCEDURE validate_tran_type1
function validateTranType1() {
	var ok = true;
	new Ajax.Request(
			contextPath + "/GIACPremDepositController?action=validateTranType1",
			{
				method : "GET",
				parameters : {
					b140IssCd : $F("txtB140IssCd"),
					b140PremSeqNo : $F("txtB140PremSeqNo"),
					instNo : parseInt(nvl($F("txtInstNo"), 0), 10),
					assdNo : $F("txtAssdNo"),
					drvAssuredName : $F("txtDrvAssuredName"),
					assuredName : $F("txtAssuredName"),
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
					// showNotice("Validating Transaction Type. Please
					// wait...");
				},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						// hideNotice("Done!");
						var resXML = response.responseXML;

						$("txtDrvAssuredName").value = /*$F("txtAssdNo") //marco - 09.26.2014 - comment out
								+ " - "
								+ */resXML.getElementsByTagName("drvAssuredName")[0].childNodes[0] == undefined ? ""
								: resXML.getElementsByTagName("drvAssuredName")[0].childNodes[0].nodeValue;
						$("txtAssuredName").value = resXML
								.getElementsByTagName("assuredName")[0].childNodes[0] == undefined ? ""
								: resXML.getElementsByTagName("assuredName")[0].childNodes[0].nodeValue;
						$("txtDspA150LineCd").value = resXML
								.getElementsByTagName("dspA150LineCd")[0].childNodes[0] == undefined ? ""
								: resXML.getElementsByTagName("dspA150LineCd")[0].childNodes[0].nodeValue;
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
						$("txtAssdNo").value = resXML.getElementsByTagName("assdNo")[0].childNodes[0] == undefined ? "" :
												resXML.getElementsByTagName("assdNo")[0].childNodes[0].nodeValue; //marco - 09.26.2014 - SR 2542
						premDepUpdatePolicyNo();
					} else {
						ok = false;
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});

	return ok;
}