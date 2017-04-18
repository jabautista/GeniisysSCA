/**
 * Shows the purge logs page
 * @author andrew robes
 * @date 06.04.2012
 * 
 */
function showPurgeLogsPage(){
	new Ajax.Request(contextPath+"/PurgeLogsController", {
		parameters: {action : "showPurgeLogsPage"},
		onCreate: showNotice("Please wait..."),
		onComplete: function(response){
			hideNotice();
			if(checkErrorOnResponse(response)){
				$("mainContents").update(response.responseText);
			}
		}
	});
}