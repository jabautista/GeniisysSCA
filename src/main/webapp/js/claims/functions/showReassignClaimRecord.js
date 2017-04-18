/**
 * Shows Reassign Claim Record Page
 * Module: GICLS044
 * @author Kenneth L.
 * 05.21.2013
 */
function showReassignClaimRecord(lineCd){
	new Ajax.Request(contextPath + "/GICLReassignClaimRecordController", {
		method : "GET",
		parameters : {action 	: "showReassignClaimRecord",
					  lineCd 	: lineCd,
					  ajax      : 1},
        onCreate   : showNotice("Loading, please wait..."),
        onComplete : function(response){
        	hideNotice();
        	try {
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch (e) {
				showErrorMessage("showReassignClaimRecord", e);
			}
        }
	});
}