/**
 * Shows Payment Request Document Maintenance module
 * @author andrew robes
 * @date 9.18.2013
 * 
 */
function showGiacs306() {
	try {
		new Ajax.Request(contextPath + "/GIACPaytReqDocController", {
				parameters : {action : "showGiacs306"},
				onCreate : showNotice("Retrieving Payment Request Document Maintenance, please wait..."),
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
		showErrorMessage("showGiacs306", e);
	}
}