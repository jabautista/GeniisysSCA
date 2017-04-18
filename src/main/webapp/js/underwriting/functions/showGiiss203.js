//Intermediary Listing Maintenance : shan 11.07.2013
function showGiiss203(){ 
	try{
		new Ajax.Request(contextPath + "/GIISIntermediaryController", {
			parameters : {
				action : "showGiiss203"
			},
			onCreate : showNotice("Loading Intermediary Listing Maintenance, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss203",e);
	}
}