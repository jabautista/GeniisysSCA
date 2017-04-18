/**
 * Shows Bank Account Maintenance module
 * @author andrew robes
 * @date 9.26.2013
 * 
 */
function showGiacs312() {
	try {
		new Ajax.Request(contextPath + "/GIACBankAccountsController", {
				parameters : {action : "showGiacs312"},
				onCreate : showNotice("Retrieving Bank Account Maintenance, please wait..."),
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
		showErrorMessage("showGiacs312", e);
	}
}