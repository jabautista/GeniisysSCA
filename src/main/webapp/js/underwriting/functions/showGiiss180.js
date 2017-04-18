//Initial/General Information Maintenance : shan 12.10.2013
function showGiiss180(){ 
	try{
		new Ajax.Request(contextPath + "/GIISGeninInfoController", {
			parameters : {
				action : "showGiiss180",
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
		showErrorMessage("showGiiss180",e);
	}
}