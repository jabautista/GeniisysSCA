/**
 * @Created By : J. Diago
 * @Date Created : 11.25.2013
 * @Description showGiacs324
 */
function showGiacs324() {
	try {
		new Ajax.Request(contextPath + "/GIACBankBookTranController", {
				parameters : {
					action : "showGiacs324"
				},
				onCreate : showNotice("Retrieving Bank and Book Transactions Maintenance, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiacs324", e);
	}
}