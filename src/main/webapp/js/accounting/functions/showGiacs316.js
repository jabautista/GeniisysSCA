/**
 * @author : Kris Felipe
 * @module : GIACS316 
 * @Date : 11.28.2013
 * @Description Shows Document Sequence per User Maintenance Page
 */
function showGiacs316() {
	try {
		new Ajax.Request(contextPath + "/GIACDocSequenceUserController", {
				parameters : {
					action : "showGiacs316"
				},
				onCreate : showNotice("Retrieving Document Sequence per User Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiacs316", e);
	}
}