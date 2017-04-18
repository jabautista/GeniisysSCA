/*
 * Shows Fund Cd (Company) List for Close DCB Emman 04.05.2011
 */
function searchDCBPayModeLOV(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACAccTransController?action=getDCBPayModeListing", {
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
					dcbNo : $F("gaccDspDCBNo")
				},
				asynchronous : true,
				evalScripts : true
			});
}