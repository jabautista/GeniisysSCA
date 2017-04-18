/**
 * Shows Subsidiary Ledger Type Maintenance module
 * @author andrew robes
 * @date 8.28.2013
 * 
 */
function showGiacs308() {
	try {
		new Ajax.Request(contextPath + "/GIACSlTypeController", {
				parameters : {action : "showGiacs308"},
				onCreate : showNotice("Retrieving Subsidiary Ledger Type Maintenance, please wait..."),
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
		showErrorMessage("showGiacs308", e);
	}
}