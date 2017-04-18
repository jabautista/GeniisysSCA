/**
 * @Created By : J. Diago
 * @Date Created : 09.10.2013
 * @Description GIACS128
 */
function showDistRegisterPolicyPerPeril() {
	try {
		new Ajax.Request(contextPath + "/GIACEndOfMonthReportsController", {
			method : "POST",
			parameters : {
				action : "showDistRegisterPolicyPerPeril"
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
				}
			}
		});
	} catch (e) {
		showErrorMessage("showDistRegisterPerTreaty", e);
	}
}