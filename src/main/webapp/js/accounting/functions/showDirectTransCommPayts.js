function showDirectTransCommPayts() {
	new Ajax.Updater("transBasicInfoSubpage", contextPath
			+ "/GIACCommPaytsController?action=showCommPayts", {
		method : "GET",
		parameters : {
			gaccTranId : objACGlobal.gaccTranId
		},
		asynchronous : true,
		evalScripts : true,
		onCreate : function() {
			showNotice("Loading Comm Payts page. Please wait...");
		},
		onComplete : function() {
			hideNotice("");
		}
	});
}