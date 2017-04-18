/**
 * Shows Treaty Type Maintenance module
 * @author fons ellarina
 * @date 11.07.2013
 * 
 */
function showGiiss094() {
	try {
		new Ajax.Request(contextPath + "/GIISCaTrtyTypeController", {
				parameters : {action : "showGiiss094"},
				onCreate : showNotice("Retrieving Treaty Type Maintenance, please wait..."),
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
		showErrorMessage("showGiiss094", e);
	}
}