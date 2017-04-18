//Signatory Name Maintenance : shan 11.27.2013
function showGiiss071(){ 
	try{
		new Ajax.Request(contextPath + "/GIISSignatoryNamesController", {
			parameters : {
				action : "showGiiss071",
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
		showErrorMessage("showGiiss071",e);
	}
}