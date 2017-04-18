// shows Recapitulation VI
function showRecapsVI() {
	try {
		objGIPIS203.fromMenu = "AC";
		new Ajax.Request(contextPath + "/GIPIPolbasicController", {
				parameters : {
					action : "showRecapsVI"
				},
				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showRecapsVI", e);
	}
}