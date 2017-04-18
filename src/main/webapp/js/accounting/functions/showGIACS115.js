function showGIACS115() {
	new Ajax.Request(
			contextPath + "/GIACGeneralLedgerReportsController",
			{
				parameters : {
					action : "showGIACS115",
					repType : "R",
					alpType : "S", //edited by MarkS 9.15.2016 SR5632,
					birFreqTagQuery : "M"
				},
				onCreate : showNotice("Loading BIR Alphalist page.  Please wait..."),
				onComplete : function(response) {
					try {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							hideAccountingMainMenus();
							$("mainContents").update(response.responseText);
							$("acExit").show();
						}
					} catch (e) {
						showErrorMessage("showGIACS115", e);
					}
				}
			});
}