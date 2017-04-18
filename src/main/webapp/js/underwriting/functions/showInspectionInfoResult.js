function showInspectionInfoResult(page, keyword){
	if (page == "" || page == null){
		page = 1;
	}
	if (keyword == null){
		keyword = $F("keyword");
	}
	new Ajax.Updater("searchResult", contextPath+"/GIPIInspectionReportController?action=searchInspectionInfo", {
		method: "POST",
		parameters: {
			pageNo: page,
			keyword: keyword
		},
		evalScripts: true,
		asynchronous: true,
		onCreate: function (){
			showNotice("Getting Inspection Information listing. Please wait...");
		},
		onComplete: function (){
			hideNotice("");
		}
	});
}