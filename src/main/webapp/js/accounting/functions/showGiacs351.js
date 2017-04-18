/**
 * @Created By : J. Diago
 * @Date Created : 11.22.2013
 * @Description showGiacs351
 */
function showGiacs351(callFrom, repCd) {
	try {
		new Ajax.Request(contextPath + "/GIACEomRepController", {
				parameters : {
					action : "showGiacs351",
					callFrom : callFrom,
					repCd : repCd
				},
				onCreate : showNotice("Retrieving Month-end Report Detail Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(callFrom == "menu"){
							$("dynamicDiv").update(response.responseText);
						} else if(callFrom == "GIACS350"){
							$("giacs350MainDiv").style.display = "none";
							$("giacs351Div").style.display = null;
							$("giacs351Div").update(response.responseText);
						}
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiacs351", e);
	}
}