/* checks the status of batch accounting process
 * returns true if there is no batch accounting process currently in progress
 */
function checkBatchAccountingProcess() {
	var ok = false;
	
	new Ajax.Request(contextPath + "/GIACParametersController?action=checkBatchAccountingProcess", {
		method: "GET",
		asynchronous: false,
		evalScripts: true,
		onComplete: function(response) {
			if (checkErrorOnResponse(response)) {
				if (response.responseText == "SUCCESS") {
					ok = true;
				} else {
					showMessageBox(response.responseText, imgMessage.INFO);
				}
			} else {
				showMessageBox(response.responseText, imgMessage.INFO);
			}
		}
	});
	
	return ok;
}