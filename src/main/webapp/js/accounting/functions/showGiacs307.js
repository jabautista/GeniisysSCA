/**
 * Shows Bank Maintenance module
 * @author andrew robes
 * @date 9.6.2013
 * 
 */
function showGiacs307() {
	try {
		new Ajax.Request(contextPath + "/GIACBankController", {
				parameters : {action : "showGiacs307"},
				onCreate : showNotice("Retrieving Bank Maintenance, please wait..."),
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
		showErrorMessage("showGiacs307", e);
	}
}