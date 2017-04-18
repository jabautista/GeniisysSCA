function showGiiss216(){
	try{
		new Ajax.Request(contextPath + "/GIISBancBranchController", {
			parameters : {
				action : "showGiiss216"
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
		showErrorMessage("showGiiss216",e);
	}
}