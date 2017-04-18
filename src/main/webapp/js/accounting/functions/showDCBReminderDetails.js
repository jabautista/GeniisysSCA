function showDCBReminderDetails() {
	var dateEntered = Date.parse($F("orDate"));
	var now = new Date();
	showConfirmBox("PROCEED DCB_NO",
			"Before continuing, please make sure no one else is creating a DCB No. for "
					+ dateEntered.format("mm-dd-yyyy") + ". Continue?", "Yes",
			"No", function() {
				if (objACGlobal.commSlip == 1)
					objACGlobal.commSlip = 1;
				showDCBNo();
			}, function() {
				if (objACGlobal.commSlip == 1)
					objACGlobal.commSlip = 0;
				cancelDCBCreation();
			});
}