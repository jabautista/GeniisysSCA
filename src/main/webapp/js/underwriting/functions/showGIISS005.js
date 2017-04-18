function showGIISS005(){
	try{
		new Ajax.Request(contextPath + "/GIISTariffController", {
			parameters : {
				action : "showGIISS005"
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
		showErrorMessage("showGIISS005",e);
	}
}