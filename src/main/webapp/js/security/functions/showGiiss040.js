function showGiiss040() {
	try {
		new Ajax.Request(contextPath + "/GIISS040Controller", {
				parameters : {action : "showGiiss040"},
				onCreate : showNotice("Retrieving Users Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiiss040", e);
	}
}