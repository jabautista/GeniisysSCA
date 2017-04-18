/**
 * Shows the GIACS047
 * 
 * @author Steven Ramirez
 * @date 04.25.2013
 */
function showUpdateCheckStatus() {
	try {
		new Ajax.Request(contextPath + "/GIACUpdateCheckStatusController", {
			parameters : {
				action : "showUpdateCheckStatus"
			},
			asynchronous : true,
			evalScripts : true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response)) {
					$("mainContents").update(response.responseText);
					hideAccountingMainMenus();
					$("acExit").hide();
					$("mainNav").hide();
				}
			}
		});
	} catch (e) {
		showErrorMessage("showUpdateCheckStatus", e);
	}
}