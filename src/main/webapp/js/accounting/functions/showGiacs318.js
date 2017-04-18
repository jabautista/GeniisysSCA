/**
 * Shows Withholding Tax Maintenance module
 * @author andrew robes
 * @date 9.6.2013
 * 
 */
function showGiacs318() {
	try {
		new Ajax.Request(contextPath + "/GIACWholdingTaxController", {
				parameters : {action : "showGiacs318"},
				onCreate : showNotice("Retrieving Withholding Tax Maintenance, please wait..."),
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
		showErrorMessage("showGiacs318", e);
	}
}