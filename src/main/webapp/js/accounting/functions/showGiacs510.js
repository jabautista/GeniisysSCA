/**
 * Shows Subsidiary Ledger Type Maintenance module
 * @author J. Diago
 * @date 09.24.2013
 * 
 */
function showGiacs510() {
	try {
		new Ajax.Request(contextPath + "/GIACBudgetController", {
				parameters : {action : "showGiacs510"},
				onCreate : showNotice("Retrieving Subsidiary of Expenses Page, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						hideAccountingMainMenus();
						$("mainContents").update(response.responseText);
						$("acExit").show();
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiacs510", e);
	}
}