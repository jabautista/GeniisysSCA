/**
 * Shows JV Transaction Type Maintenance module
 * @author andrew robes
 * @date 9.6.2013
 * 
 */
function showGiacs323() {
	try {
		new Ajax.Request(contextPath + "/GIACJvTranController", {
				parameters : {action : "showGiacs323"},
				onCreate : showNotice("Retrieving JV Transaction Type Maintenance, please wait..."),
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
		showErrorMessage("showGiacs323", e);
	}
}