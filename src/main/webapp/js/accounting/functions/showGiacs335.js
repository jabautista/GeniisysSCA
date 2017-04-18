function showGiacs335(){
	new Ajax.Request(contextPath + "/GIACSoaTitleController", {
		method : "POST",
		parameters : {action 	: "showGiacs335"},
        onCreate   : showNotice("Retrieving SOA Title Maintenance, please wait..."),
        onComplete : function(response){
        	hideNotice();
			if(checkErrorOnResponse(response)){
				hideAccountingMainMenus();
				$("mainContents").update(response.responseText);
				$("acExit").show();
			}
        }
	});
}