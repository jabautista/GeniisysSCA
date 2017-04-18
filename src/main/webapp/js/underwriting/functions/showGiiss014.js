function showGiiss014(){
	try{
		new Ajax.Request(contextPath + "/GIISIndustryController", {
			parameters : {
				action : "showGiiss014"
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
		showErrorMessage("showAssuredTypeMaintenance",e);
	}
}