/**
 * @Created By : J. Diago
 * @Date Created : 11.21.2013
 * @Description showGiacs350
 */
function showGiacs350() {
	try {
		new Ajax.Request(contextPath + "/GIACEomRepController", {
				parameters : {
					action : "showGiacs350"
				},
				onCreate : showNotice("Retrieving Month-end Report Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiacs350", e);
	}
}