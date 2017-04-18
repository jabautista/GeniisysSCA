/**
 * Show Claims Distribution - GICLS255
 * @author A. Pascual
 * 06.07.2013
 */
function showClaimDistribution(){
	try{
		objCLMGlobal = new Object();
		objCLMGlobal.moduleId = "GICLS255";
		setModuleId(objCLMGlobal.moduleId);
		setDocumentTitle("Claim Distribution");
		new Ajax.Updater("dynamicDiv",contextPath+"/GICLClaimsController",{
			method : "GET",
			parameters : {
				action 	: "showClaimDistribution"
					},
	        onCreate   : showNotice("Loading, please wait..."),
	        onComplete : function(response){
	        	hideNotice();
	        	try {
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				} catch (e) {
					showErrorMessage("showClaimDistribution", e);
				}
	        }
		});
	}catch (e) {
		showErrorMessage("showClaimDistribution", e);
	}
}