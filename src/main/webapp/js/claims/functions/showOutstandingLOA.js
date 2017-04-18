/**
 * show outstanding LOA
 * Module: GICLS219
 * @author Gzelle
 * 07.30.2013
 */
function showOutstandingLOA(){
	new Ajax.Request(contextPath + "/GICLClaimReportsController", {
		method : "GET",
		parameters : {action 	: "showOutstandingLOA"},
        onCreate   : showNotice("Loading, please wait..."),
        onComplete : function(response){
        	hideNotice();
        	try {
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch (e) {
				showErrorMessage("showOutstandingLOA", e);
			}
        }
	});
}