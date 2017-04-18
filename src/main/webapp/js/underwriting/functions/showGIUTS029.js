function showGIUTS029(){
	try {
		new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
				parameters : {action : "showGIUTS029"},
				onCreate : showNotice("Getting Update Picture Attachment, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGIUTS029",e);
	}
}