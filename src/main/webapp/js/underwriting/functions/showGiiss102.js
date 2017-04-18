// Collateral Type Maintenance : shan 10.22.2013
function showGiiss102(){ 
	try{
		new Ajax.Request(contextPath + "/GIISCollateralTypeController", {
			parameters : {
				action : "showGiiss102",
			},
			onCreate : showNotice("Loading Collateral Type Maintenance, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	}catch(e){
		showErrorMessage("showGiiss102",e);
	}
}