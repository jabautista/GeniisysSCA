
/*
 * Shows DCB Date LOV List for Close DCB Emman 03.31.2011
 */
function searchDCBDateLOV(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACCollnBatchController?action=getDCBDateListing", {
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
					gfunFundCd : $F("dcbDateLOVFundCd"),
					gibrBranchCd : $F("dcbDateLOVBranchCd")
				},
				asynchronous : true,
				evalScripts : true
			});
}