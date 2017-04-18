/**
 * Shows the GIACB000
 * 
 * @author Steven Ramirez
 * @date 04.11.2013
 */
function showBatchAccountingEntry() {
	try {
		new Ajax.Request(
				contextPath
						+ "/GIACBatchAcctEntryController?action=showBatchAccountingEntry",
				{
					asynchronous : true,
					evalScripts : true,
					onCreate : function() {
						showNotice("Loading, please wait...");
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							$("dynamicDiv").update(response.responseText);
						}
					}
				});
	} catch (e) {
		showErrorMessage("showBatchAccountingEntry", e);
	}
}