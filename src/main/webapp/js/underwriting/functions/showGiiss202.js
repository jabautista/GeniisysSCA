function showGiiss202(){
	try{
		new Ajax.Request(contextPath + "/GIISSplOverrideRtController", {
			parameters : {
				action : "showGiiss202"
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
		showErrorMessage("showGiiss202",e);
	}
}