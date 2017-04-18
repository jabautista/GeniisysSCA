/*
 * Pol Cruz 06.13.2013 Credit/Debit Memo Report
 */
function showGIACS072() {
	try {
		new Ajax.Request(contextPath + "/GIACMemoController", {
			parameters : {
				action : "showGIACS072"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					hideAccountingMainMenus();
					$("mainContents").update(response.responseText);
					$("acExit").show();
				}
			}
		});
	} catch (e) {
		showErrorMessage("Credit/Debit Memo Report", e);
	}
}