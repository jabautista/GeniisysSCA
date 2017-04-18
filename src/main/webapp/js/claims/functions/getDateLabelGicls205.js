function getDateLabelGicls205(){
	var dateLabel = "";
	dateLabel = $("rdoIssueDate").checked ? "Issue Date" : $("rdoAcctEntryDate").checked ? "Acct Entry Date" : "Booking Date";
	return dateLabel;
}