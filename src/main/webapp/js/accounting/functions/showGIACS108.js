// bonok :: 07.18.2013 :: GIACS108
function showGIACS108() {
	new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController", {
		parameters : {
			action : "showGIACS108"
		},
		onCreate : showNotice("Loading EVAT page.  Please wait..."),
		onComplete : function(response) {
			try {
				hideNotice("");
				if (checkErrorOnResponse(response)) {
					hideAccountingMainMenus();
					$("mainContents").update(response.responseText);
					$("acExit").show();
				}
			} catch (e) {
				showErrorMessage("showGIACS108 - onComplete : ", e);
			}
		}
	});
}