/*
 * Shows Branch Cd (Branch) List for Close DCB Emman 03.30.2011
 */
function searchBranchCdLOV(pageNumber) {
	new Ajax.Updater("searchResult",
			"GIACBranchController?action=getCloseDCBBranchCdListing", {
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
					gfunFundCd : $F("branchCdLOVFundCd"),
					moduleId : $F("branchCdLOVModuleId")
				},
				asynchronous : true,
				evalScripts : true
			});
}