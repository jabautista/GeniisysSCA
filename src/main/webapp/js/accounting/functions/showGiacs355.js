/**
 * @author : Kris Felipe
 * @Date : 11.22.2013
 * @Description Shows OR Prefix Maintenance Page
 */
function showGiacs355() {
	try {
		new Ajax.Request(contextPath + "/GIACOrPrefController", {
				parameters : {
					action : "showGiacs355"
				},
				onCreate : showNotice("Retrieving OR Prefix Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiacs355", e);
	}
}