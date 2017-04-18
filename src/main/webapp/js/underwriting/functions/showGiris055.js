/**
 * Shows View Binder Status Module (Inquiry)
 * @author J. Diago
 * @date 10.02.2013
 * 
 */
function showGiris055() {
	try {
		new Ajax.Request(contextPath + "/GIRIBinderController", {
			method: "GET",
			parameters : {
				action : "showGiris055"
			},
			evalScripts:true,
			asynchronous: true,
			onCreate : showNotice("Retrieving View Binder Status Page, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					$("mainContents").update(response.responseText);
				}
			}
		});
	} catch(e){
		showErrorMessage("showGiris055", e);
	}
}