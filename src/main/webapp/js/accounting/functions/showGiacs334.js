/**
 * @Created By : J. Diago
 * @Date Created : 11.27.2013
 * @Description showGiacs334
 */
function showGiacs334() {
	try {
		new Ajax.Request(contextPath + "/GIACIntmPcommRtController", {
				parameters : {
					action : "showGiacs334"
				},
				onCreate : showNotice("Retrieving Profit Commission Rate Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiacs334", e);
	}
}