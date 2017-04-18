function showGiiss218(){
	try{
		new Ajax.Request(contextPath + "/GIISBancTypeController", {
			parameters : {
				action : "showGiiss218"
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
		showErrorMessage("showGiiss218",e);
	}
}