/**
 * Description: Get date cancelled
 * @author Niknok 11.04.11
 * */
function getClmAdjDateCancelled(adjCompanyCd){
	try{
		var date = "";
		new Ajax.Request(contextPath+"/GICLClaimsController",{
			parameters: {
				action: "getDateCancelled",
				adjCompanyCd: adjCompanyCd
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					date = response.responseText;
				}	
			}	
		});
		return date;
	}catch(e){
		showErrorMessage("getDateCancelledMsg", e);	
	}	
}