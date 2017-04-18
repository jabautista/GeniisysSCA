/**
 * Check User Access for GICLS
 * @author Shan Bati 03.14.2013
 */
function checkUserAccessGicls(moduleId){
	try{
		new Ajax.Request(contextPath+"/GIISUserController",{
			method: "GET",
			parameters: {
				action:		"checkUserAccessGicls",
				moduleId:	moduleId
			},
			asynchronous: true,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == 1){
						if(moduleId == "GICLS201"){
							showClaimsRecoveryRegisterPage();
						}else if(moduleId == "GICLS255"){
							showClaimDistribution();
						}else if(moduleId == "GICLS220"){
							showBiggestClaims();
						}
					}else{
						showMessageBox("You are not allowed to access this module.", "E");
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("checkUserAccessGicls", e);
	}
}