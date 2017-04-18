// get the quote if of the selected quotation in the quotation listing table
// return: quoteId of the selected row
function getQuotationSelectedRow(){
	var quoteId = 0;
	$$("div#quotationListingTable div[name='row']").each(function(row) {
		if (row.hasClassName("selectedRow")) {
			quoteId = row.down("input", 0).value;
		}
	});
	return quoteId;
}