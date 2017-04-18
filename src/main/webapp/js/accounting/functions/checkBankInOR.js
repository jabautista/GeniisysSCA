function checkBankInOR() {
	var exist = "Y";

	new Ajax.Request(contextPath
			+ "/GIACAccTransController?action=checkBankInOR", {
		evalScripts : true,
		asynchronous : false,
		method : "GET",
		parameters : {
			gfunFundCd : $F("gaccGfunFundCd"),
			gibrBranchCd : $F("gaccGibrBranchCd"),
			dcbYear : $F("gaccDspDCBYear"),
			dcbNo : $F("gaccDspDCBNo")
		},
		onComplete : function(response) {
			if (checkErrorOnResponse(response)) {
				exist = nvl(response.responseText, "N");
			} else {
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});

	return exist;
}