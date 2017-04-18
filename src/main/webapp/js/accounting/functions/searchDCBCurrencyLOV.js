/*
 * Shows Currency LOV for Close DCB - Emman 04.07.2011
 */
function searchDCBCurrencyLOV(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIISCurrencyController?action=getDCBCurrencyListing", {
				onCreate : function() {
					showLoading("searchResult", "Getting list, please wait...",
							"100px");
				},
				onException : function() {
					showFailure('searchResult');
				},
				parameters : {
					pageNo : pageNumber,
					keyword : $F("keyword"),
					gfunFundCd : $F("gaccGfunFundCd"),
					gibrBranchCd : $F("gaccGibrBranchCd"),
					dcbDate : $F("gaccDspDCBDate"),
					dcbNo : $F("gaccDspDCBNo"),
					payMode : $F("dcbCurrencyLOVPayMode")
				},
				asynchronous : true,
				evalScripts : true
			});
}