function showGiiss165(){
	try{
		new Ajax.Request(contextPath + "/GIISDefaultDistController", {
			parameters : {
				action : "showGiiss165"
			},
			asynchronous: false,
			evalScripts:true,
			onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss165",e);
	}
}
