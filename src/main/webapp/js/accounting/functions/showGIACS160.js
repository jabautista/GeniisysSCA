// Joms 06.19.2013
function showGIACS160() {
	try {
		new Ajax.Request(
				contextPath + "/GIACOfficialReceiptRegisterController",
				{
					method : "POST",
					parameters : {
						action : "showGIACS160"
					},
					evalScripts : true,
					asynchronous : true,
					onCreate : function() {
						showNotice("Loading Official Receipt Register, please wait...");
					},
					onComplete : function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showGIACS160", e);
	}
}