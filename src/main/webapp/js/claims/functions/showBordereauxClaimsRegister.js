function showBordereauxClaimsRegister(){
	new Ajax.Request(contextPath + "/GICLBrdrxClmsRegisterController", {
	    parameters : {action : "showBordereauxClaimsRegister"},
	    onCreate : showNotice("Loading, please wait..."),
		onComplete : function(response){
			hideNotice();
			try {
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showBordereauxClaimsRegister: ", e);
			}
		}
	});
}