function showGiiss115(){
	try{
		new Ajax.Request(contextPath + "/GIISMcCarCompanyController", {
			parameters : {
				action : "showGiiss115"
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
		showErrorMessage("showGiiss115",e);
	}
}