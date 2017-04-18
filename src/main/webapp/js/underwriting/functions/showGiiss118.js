function showGiiss118(){
	try{
		new Ajax.Request(contextPath + "/GIISGroupController", {
			parameters : {
				action : "showGiiss118"
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
		showErrorMessage("showAssuredGroupMaintenance",e);
	}
}