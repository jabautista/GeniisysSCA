function showGiiss215(){
	try{
		new Ajax.Request(contextPath + "/GIISBancAreaController", {
			parameters : {
				action : "showGiiss215"
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
		showErrorMessage("showGiiss215",e);
	}
}