// moved from accountingEntries.jsp
function closeTrans() {
	try {
		if (parseFloat($("txtDifference").value) != 0) {
			showMessageBox("Unable to close transaction. Debit and Credit amounts are not equal.");
		} else {
			new Ajax.Request(contextPath
					+ "/GIACAcctEntriesController?action=closeTrans", {
				method : "POST",
				parameters : {
					gaccTranId : objACGlobal.gaccTranId
				},
				onCreate : function() {
					showNotice("Closing the transaction, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						if (response.responseText == ""
								|| response.responseText == "SUCCESS") {
							disableButton($("btnCloseTrans"));
							objAC.tranFlagState = "C"; // added by steven to
														// update it. 02.18.2013
							showWaitingMessageBox("Transaction Closed.",		/*modified by Gzelle 04012016 AP/AR*/
									imgMessage.SUCCESS, function() {
										accountingEntriesTableGrid.refresh();
									});
						} else {
							showMessageBox(response.responseText, "e");
						}
					}
				}
			});
		}
	} catch (e) {
		showErrorMessage("closeTrans", e);
	}
}