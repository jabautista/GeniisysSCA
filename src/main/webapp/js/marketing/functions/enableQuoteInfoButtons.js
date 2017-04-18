// enable the buttons in the quotation information page
function enableQuoteInfoButtons() {
	if (quoteInfoSaveIndicator == 1) {
		if (getSelectedRowId("row") != "") {
			enableButton("btnAdditionalInformation");
			enableButton("btnMortgageeInformation");
			enableButton("btnInvoice");
			enableButton("btnAttachedMedia");
		}
		enableButton("btnPrintQuotation");
	}
}