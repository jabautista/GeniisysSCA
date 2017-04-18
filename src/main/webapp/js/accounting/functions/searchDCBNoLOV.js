/*
 * Shows DCB No LOV List for Close DCB Emman 03.31.2011
 */
function searchDCBNoLOV(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACCollnBatchController?action=getDCBNoListing", {
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
					gfunFundCd : $F("dcbNoLOVFundCd"),
					gibrBranchCd : $F("dcbNoLOVBranchCd"),
					dcbDate : $F("dcbNoLOVDCBDate"),
					dcbYear : $F("dcbNoLOVDCBYear")
				},
				asynchronous : true,
				evalScripts : true
			});
}