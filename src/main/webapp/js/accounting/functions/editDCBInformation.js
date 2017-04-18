// moved from dcbListing.jsp
function editDCBInformation() {
	new Ajax.Updater("mainContents", contextPath
			+ "/GIACAccTransController?action=editDCBInformation", {
		method : "GET",
		asynchronous : true,
		evalScripts : true,
		parameters : {
			gaccTranId : objACGlobal.gaccTranId
		},
		onCreate : function() {
			showNotice("Loading, please wait...");
		},
		onComplete : function(response) {
			if (checkErrorOnResponse(response)) {
				hideNotice("");
			}
		}
	});
}