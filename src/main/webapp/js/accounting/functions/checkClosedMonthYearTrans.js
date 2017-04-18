// moved from officialReceiptInformation.jsp and modified by christian
// 09.27.2012
function checkClosedMonthYearTrans(month, year) {
	var isClosed = true;
	var spMonth = [ "January", "February", "March", "April", "May", "June",
			"July", "August", "September", "October", "November", "December"];
	if (objACGlobal.objClosedTranArray != null) {
		for ( var i = 0; i < objACGlobal.objClosedTranArray.length; i++) {
			if (month == (objACGlobal.objClosedTranArray[i].tranMm - 1)
					&& year == objACGlobal.objClosedTranArray[i].tranYr) {
				// showMessageBox("You are no longer allowed to create a
				// transaction for " + spMonth[month] + " " + year +" This
				// Transaction Month is already closed.", imgMessage.INFO);
				// commented out and modified by Kris 01.30.2013: check if month
				// is permanently or temporarily closed for transaction.
				showMessageBox(
						"You are no longer allowed to create a transaction for "
								+ spMonth[month]
								+ " "
								+ year
								+ ". This Transaction Month is "
								+ (objACGlobal.objClosedTranArray[i].closedTag == "T" ? "temporarily"
										: "already") + " closed.",
						imgMessage.INFO);
				$("orDate").value = serverDate.format("mm-dd-yyyy");
				isClosed = false;
			}
		}
	}
	return isClosed;
}