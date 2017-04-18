/* Shows Special Claims Settlement Request Inquiries
 * Shan 07.17.2014
 */
function showGIACS087(){
	try {
		new Ajax.Request(contextPath + "/GIACBatchDVController", {
		    parameters : {action : "showGIACS087"},
		    onCreate: showNotice("Loading, Please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("dynamicDiv").update(response.responseText);
				}
			} 
		});
	} catch(e){
		showErrorMessage("showGicls059", e);
	}	
}