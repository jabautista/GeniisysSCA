/**
 * Check if total share percentage of intm is over 100 %
 * 
 * @author Carlo Rubenecia
 * @param
 */
function checkSharePercentage(claimId, perilCd, itemNo) {
	var rep = 'Y';
	var message = "";
	
	new Ajax.Request(contextPath+"/GICLClaimsController?", {
		method: "GET",
		parameters: {
			action: "checkSharePercentage",
			claimId : claimId,
			perilCd : perilCd,
			itemNo : itemNo
		},
		evalScripts: true,
		asynchronous: false,
		onComplete: function (response) {
			if(checkErrorOnResponse(response)){
				message = response.responseText;
				rep = message;
			}
		}
	});
	return rep;
}