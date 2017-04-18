// PROCEDURE get_par_seq_no2
function getParSeqNo2() {
	var ok = true;
	new Ajax.Request(contextPath
			+ "/GIACPremDepositController?action=getParSeqNo2", {
		method : "GET",
		parameters : {
			assdNo : $F("txtAssdNo"),
			lineCd : $F("txtLineCd"),
			sublineCd : $F("txtSublineCd"),
			issCd : $F("txtIssCd"),
			issueYy : $F("txtIssueYy"),
			polSeqNo : $F("txtPolSeqNo"),
			b140IssCd: $F("txtB140IssCd"),
			b140PremSeqNo: $F("txtB140PremSeqNo")
		},
		asynchronous : false,
		evalScripts : true,
		onCreate : function() {
			// showNotice("Validating Transaction Type. Please wait...");
		},
		onComplete : function(response) {
			if (checkErrorOnResponse(response)) {
				// hideNotice("Done!");
				var result = response.responseText.toQueryParams();

				$("txtParLineCd").value = result.parLineCd;
				$("txtParIssCd").value = result.parIssCd;
				$("txtParYy").value = result.parYy;
				$("txtParSeqNo").value = result.parSeqNo;
				$("txtQuoteSeqNo").value = result.quoteSeqNo;

				premDepUpdateParNo();
			} else {
				ok = false;
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});

	return ok;
}