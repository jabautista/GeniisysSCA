/**
 * Displays list of intermediary based on specified LOV name
 * @param pageNumber -  page no. of record
 * @param lovName	 -  name of LOV
 * @return
 */
function showGipis085IntmAjaxResult(pageNumber, lovName) {
	new Ajax.Updater("searchResult", "GIISIntermediaryController?action=getGipis085IntermediaryListing", {
		onCreate: function() { 
			showLoading("searchResult", "Getting list, please wait...", "100px");
		}, 
		onException: function() { 
			showFailure('searchResult');
		},
		parameters: {
			pageNo: pageNumber,
			keyword: $F("keyword"),
			lovName: lovName,
			assdNo: $F("txtB240AssdNo"),
			lineCd: $F("txtB240LineCd"),
			parId: $F("txtB240ParId")
		},
		asynchronous: true, 
		evalScripts: true
	});
}