function showGIPIS902(){
	try{
		new Ajax.Request(contextPath + "/GIPIRiskLossProfileController", {			
			parameters : {action : "showGIPIS902"},
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGIPIS902", e);
	}
}