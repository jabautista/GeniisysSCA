function showGiacs311() {
	try {
		new Ajax.Request(contextPath + "/GIACChartOfAcctsController", {
				parameters : {action : "showGiacs311"},
				onCreate : showNotice("Retrieving Chart Of Accounts Maintenance, please wait..."),
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
		showErrorMessage("showGiacs311", e);
	}
}