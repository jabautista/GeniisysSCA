/**
 * Description: Check if private adjuster exist
 * @author Niknok 11.04.11
 * */
function checkClmPrivAdjExist(adjCompanyCd){
	try{
		var ok = "N";
		new Ajax.Request(contextPath+"/GICLClaimsController",{
			parameters: {
				action: "checkPrivAdjExist",
				adjCompanyCd: adjCompanyCd
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "Y"){
						ok = "Y";
					}	
				}	
			}	
		});
		return ok;
	}catch(e){
		showErrorMessage("checkPrivAdjExist", e);	
	}	
}