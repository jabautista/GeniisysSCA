function showGIISS082(){
	try{
		new Ajax.Request(contextPath + "/GIISIntmSpecialRateController", {
			parameters : {
				action : "showGIISS082"
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
		showErrorMessage("showGIISS082",e);
	}
}