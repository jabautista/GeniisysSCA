function showGiiss012(){
	try{
		new Ajax.Request(contextPath + "/GIISFiItemTypeController", {
			parameters : {
				action : "showGiiss012"
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
		showErrorMessage("showGiiss012",e);
	}
}