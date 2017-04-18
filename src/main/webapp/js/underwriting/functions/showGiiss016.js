function showGiiss016(){
	try{
		new Ajax.Request(contextPath + "/GIISNotaryPublicController", {
			parameters : {
				action : "showGiiss016"
			},
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					//$("mainContents").update(response.responseText);
					if(objUW.fromMenu == "notaryPublic"){
						$("mainContents").update(response.responseText);
					} else if(objUW.fromMenu == "bondPolicyData"){
						$("parInfoDiv").update(response.responseText);
						$("parInfoMenu").hide();
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss016",e);
	}
}