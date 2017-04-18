function showGiiss043(){
	try{
		new Ajax.Request(contextPath + "/GIISBondClassController", {
			parameters : {
				action : "showGiiss043"
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
		showErrorMessage("showGiiss043",e);
	}
}