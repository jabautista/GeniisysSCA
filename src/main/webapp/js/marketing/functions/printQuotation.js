function printQuotation() {
	var quoteId = getQuotationSelectedRow();

	if ($$("div#quotationListingTable div[name='itemRow']").size() == 0){
		quoteId = objGIPIQuote.quoteId;
	}

	if (quoteId == 0 && (typeof errorMessage) != undefined) {
		showQuotationListingError("Please select a quotation.");
		return false;
	} else {
		Modalbox.show(contextPath + "/PrintController?action=showPrintOptions&ajaxModal=1&quoteId="	+ quoteId, {
			title : "Print Quotation",
			width : 400
		});
	}
}