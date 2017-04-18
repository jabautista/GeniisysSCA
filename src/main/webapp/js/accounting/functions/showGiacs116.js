/**
 * Shows ANLA Covered Transaction Reports
 * @author Kenneth L.
 * @date 09.30.2013
 * 
 */
function showGiacs116() {
	try {
		new Ajax.Request(contextPath + "/GIACAmlaCoveredTransactionController", {
				parameters : {action : "showAmlaCoveredTransactionReports"},
				onCreate : showNotice("Loading AMLA Covered Transaction Reports, Please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("dynamicDiv").update(response.responseText);
					}
				}
			});
	} catch(e){
		showErrorMessage("showGiacs116", e);
	}
}