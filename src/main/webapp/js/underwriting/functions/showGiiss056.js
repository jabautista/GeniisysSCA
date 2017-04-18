function showGiiss056(){
	try{
		new Ajax.Request(contextPath + "/GIISMCSublineTypeController", {
			parameters : {
				action : "showGiiss056"
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
		showErrorMessage("showGiiss056",e);
	}
}