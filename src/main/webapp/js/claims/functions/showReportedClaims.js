/**
 * show Reported Claims
 * Module: GICLS540
 * @author Gzelle
 * 08.01.2013
 */
function showReportedClaims(){
	new Ajax.Request(contextPath + "/GICLClaimReportsController", {
		method : "GET",
		parameters : {action 	: "showReportedClaims"},
        onCreate   : showNotice("Loading Reported Claims, please wait..."),
        onComplete : function(response){
        	hideNotice();
        	try {
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch (e) {
				showErrorMessage("showReportedClaims", e);
			}
        }
	});
}