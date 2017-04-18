function showGIISS108(){
	try{
		new Ajax.Request(contextPath + "/GIISControlTypeController", {
			parameters : {
				action : "showGiiss108"
			},
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss108",e);
	}
}