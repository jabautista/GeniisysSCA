/**
 * Shows Binder Status Maintenance module
 * @author J. Diago
 * @date 9.19.2013
 * 
 */
function showGiiss209() {
	try {
		new Ajax.Request(contextPath + "/GIISBinderStatusController", {
				parameters : {action : "showGiiss209"},
				onCreate : showNotice("Retrieving Binder Status Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						$("uwExit").show();
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiiss209", e);
	}
}