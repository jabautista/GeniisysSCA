/**
 * @Created By : J. Diago
 * @Date Created : 11.19.2013
 * @Description showGiacs352
 */
function showGiacs352() {
	try {
		new Ajax.Request(contextPath + "/GIACEomCheckingScriptsController", {
				parameters : {
					action : "showGiacs352"
				},
				onCreate : showNotice("Retrieving Month-end Checking Scripts Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiacs352", e);
	}
}