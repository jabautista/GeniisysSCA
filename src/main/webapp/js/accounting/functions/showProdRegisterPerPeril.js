/**
 * @Created By : steven
 * @Date Created : 07.05.2013
 * @Description GIACS111
 */
function showProdRegisterPerPeril() {
	try {
		new Ajax.Request(contextPath + "/GIACEndOfMonthReportsController", {
			method : "POST",
			parameters : {
				action : "showProdRegisterPerPeril"
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