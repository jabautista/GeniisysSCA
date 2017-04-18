function showGiiss201(){
	try{
		new Ajax.Request(contextPath + "/GIISIntmdryTypeRtController", {
			parameters : {
				action : "showGiiss201"
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
		showErrorMessage("showGiiss201",e);
	}
}