// bonok :: 07.19.2013 :: GIACS110
function showGIACS110() {
	new Ajax.Request(
			contextPath + "/GIACGeneralLedgerReportsController",
			{
				parameters : {
					action : "showGIACS110"
				},
				onCreate : showNotice("Loading Print Taxes Withheld from Payees page.  Please wait..."),
				onComplete : function(response) {
					try {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							hideAccountingMainMenus();
							$("mainContents").update(response.responseText);
							$("acExit").show();
						}
					} catch (e) {
						showErrorMessage("showGIACS110 - onComplete : ", e);
					}
				}
			});
}