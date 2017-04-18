/**
 * Gets the quote id of the current package quotation selected. 
 * @return quoteId - the quote id of the selected quotation under the Package PAR
 */

function getSelectedPackQuoteId(){
	var quoteId;
	
	if(($$("div#packQuotationListDiv .selectedRow"))[0] != undefined){
		quoteId = ($$("div#packQuotationListDiv .selectedRow"))[0].getAttribute("quoteId");
	}else{
		showMessageBox("There is no quotation selected.");
		quoteId = "";
	}
	return quoteId;
}