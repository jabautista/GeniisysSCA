/**
 * Creates a new div that will hold the quote item peril row
 * @param perilObj - JSON Object that contains the quote item peril information
 * 
 */

function createQuoteItemPerilRow(perilObj){
	var content = prepareQuoteItemPerilTable(perilObj);
	var perilRow = new Element("div");
	
	perilRow.setAttribute("id", "perilRow" + perilObj.quoteId + perilObj.itemNo + perilObj.perilCd);
	perilRow.setAttribute("name", "perilRow");
	perilRow.setAttribute("quoteId", perilObj.quoteId);
	perilRow.setAttribute("itemNo", perilObj.itemNo);
	perilRow.setAttribute("perilCd", perilObj.perilCd);
	perilRow.addClassName("tableRow");
	perilRow.update(content);
	return perilRow;
}