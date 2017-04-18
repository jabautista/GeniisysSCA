/**
 * Shows View Enrollee Information (Inquiry)
 * @author J. Diago
 * @date 10.08.2013
 * 
 */
function showGipis212() {
	try {
		new Ajax.Request(contextPath + "/GIPIGroupedItemsController", {
			method: "GET",
			parameters : {
				action : "showGipis212"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate : showNotice("Retrieving View Enrollee Information, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showGipis212", e);
	}
}