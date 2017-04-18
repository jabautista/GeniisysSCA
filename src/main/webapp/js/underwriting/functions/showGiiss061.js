function showGiiss061(){
	try{
		new Ajax.Request(contextPath + "/GIISParameterController", {
			parameters : { action : "showGiiss061"},
			onCreate : function(){showNotice("Retrieving Program Parameter Maintenance, please wait...");},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss061",e);
	}
}