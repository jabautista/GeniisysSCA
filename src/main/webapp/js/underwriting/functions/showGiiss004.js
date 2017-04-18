//Issuing Source Maintenance : shan 11.05.2013
function showGiiss004(){ 
	try{
		new Ajax.Request(contextPath + "/GIISISSourceController", {
			parameters : {
				action : "showGiiss004",
			},
			onCreate : showNotice("Loading Issuing Source Maintenance, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss004",e);
	}
}