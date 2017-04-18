function showUWRecapsVI() {
	try {
		objGIPIS203.fromMenu = "UW";
		new Ajax.Request(contextPath + "/GIPIPolbasicController",
				{
					parameters : {action : "showRecapsVI"},
					asynchronous : false,
					evalScripts : true,
					onCreate : function() {
						showNotice("Loading, please wait...");
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							$("mainContents").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showUWRecapsVI", e);
	}
}