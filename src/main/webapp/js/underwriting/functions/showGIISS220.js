function showGIISS220(){
	try{
		new Ajax.Request(contextPath + "/GIISSlidCommController", {
			parameters : {
				action : "showGIISS220"
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
		showErrorMessage("showGIISS220",e);
	}
}