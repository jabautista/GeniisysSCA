/**
 * Shows Budget Maintenance
 * @author msison
 * @date 11.29.2013
 * 
 */
function showGiacs360() {
	try {
		new Ajax.Request(contextPath + "/GIACProdBudgetController", {
				parameters : {action : "showGiacs360"},
				onCreate : showNotice("Retrieving Budget Maintenance, please wait..."),
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
		showErrorMessage("showGiacs360", e);
	}
}