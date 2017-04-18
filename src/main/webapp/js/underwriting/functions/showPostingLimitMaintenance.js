/**
 * Show Posting Limit Maintenance 
 * Module : GIISS207 Posting Limit Maintenance
 * @author Mae Legaspi
 * @author modified by: msison
 * @remarks modified 11.14.2012 - changed updater to request
 */
function showPostingLimitMaintenance(){
	new Ajax.Request(contextPath + "/GIISPostingLimitController", {
	    parameters : {action : "getPostingLimits"},
	    onCreate: showNotice("Loading Posting Limit, please wait..."),
		onComplete : function(response){
			try {
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} catch(e){
				showErrorMessage("showPostingLimitMaintenance - onComplete : ", e);
			}								
		} 
	});
}