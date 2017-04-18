/*
 * Shows Intermediary List associated with table GIIS_BANC_TYPE_DTL
 * Emman 12/21/10
 */
function showBancaIntermediaryAjaxResult(pageNumber){
	new Ajax.Updater("searchResult", "GIISIntermediaryController?action=getBancaIntermediaryListing", {
		onCreate: function() { 
			showLoading("searchResult", "Getting list, please wait...", "100px");
		}, 
		onException: function() { 
			showFailure('searchResult');
		},
		parameters: {
			pageNo: pageNumber,
			keyword: $F("keyword"),
			bancTypeCd: $F("txtBancTypeCd"),
			intmType: $F("txtBancaIntmType")
		},
		asynchronous: true, 
		evalScripts: true
	});
}