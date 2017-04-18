/**
 * Shows Department Maintenance module
 * @author andrew robes
 * @date 8.16.2013
 * 
 */
function showGiacs305() {
	try {
		new Ajax.Request(contextPath + "/GIACOucsController", {
				parameters : {action : "showGiacs305"},
				onCreate : showNotice("Retrieving Department Maintenance, please wait..."),
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
		showErrorMessage("showGiacs305", e);
	}
}