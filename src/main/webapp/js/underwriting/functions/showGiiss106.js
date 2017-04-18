//Default Peril Rate Maintenance : shan 12.19.2013
function showGiiss106(){
	try{
		new Ajax.Request(contextPath + "/GIISTariffRatesHdrController", {
			parameters : {
				action : "showGiiss106",
				moduleId: "GIISS106"
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
		showErrorMessage("showGiiss106",e);
	}
}