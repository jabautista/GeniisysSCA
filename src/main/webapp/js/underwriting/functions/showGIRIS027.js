function showGIRIS027(){
	try{
		new Ajax.Request(contextPath + "/GIRIInpolbasController", {
			parameters : {action : "showInitialAcceptance"},
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGIRIS027", e);
	}
}