// Joms 06.20.2013
function showGIACS104() {
	try {
		new Ajax.Request(
				contextPath + "/GIACInputVatReportController",
				{
					method : "POST",
					parameters : {
						action : "showInputVatReport"
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Loading Input VAT Accounting Entry Report Call, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGIACS104", e);
	}
}