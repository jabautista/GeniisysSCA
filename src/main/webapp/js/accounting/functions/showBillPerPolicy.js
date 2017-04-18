//added by john dolon 8.15.2013
function showBillPerPolicy() {
	try {
		new Ajax.Request(contextPath
				+ "/GIACInquiryController", {
			parameters : {
				action : "showBillPerPolicy"
			},
			onCreate : function() {
				showNotice("Loading Total Collections, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					$("dynamicDiv").update(response.responseText);
				}
			}
		});
	} catch (e) {
		showErrorMessage("showBillPerPolicy", e);
	}
}