function searchInspector(pageNumber){
	new Ajax.Updater("searchResult", "GIPIInspectionReportController?action=getInspectorListing", {
		parameters: {
			pageNo: nvl(pageNumber, 1),
			keyword: $F("keyword")
		},
		asynchronous: true, 
		evalScripts: true,
		onCreate: function() { 
			showLoading("searchResult", "Getting list, please wait...", "100px");
		}
	});
}