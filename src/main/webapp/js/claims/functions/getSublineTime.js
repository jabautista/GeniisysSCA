/**
 * Description: Retrieve subline time per line and subline
 * @author Niknok 10.10.11
 * */
function getSublineTime(lineCd, sublineCd){
	try{
		var sublineTime = "";
		new Ajax.Request(contextPath+"/GICLClaimsController",{
			parameters: {
				action: "getSublineTime",
				lineCd: lineCd,
				sublineCd: sublineCd
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					sublineTime = response.responseText;
				}
			}
		});
		return sublineTime;
	}catch(e){
		showErrorMessage("getSublineTime", e);
	}
}