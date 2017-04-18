/**
 * Shows Peril Class Maintenance module
 * @author andrew robes
 * @date 10.22.2013
 * 
 */
function showGiiss063() {
	try {
		new Ajax.Request(contextPath + "/GIISClassController", {
				parameters : {action : "showGiiss063"},
				onCreate : showNotice("Retrieving Peril Class Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiiss063", e);
	}
}