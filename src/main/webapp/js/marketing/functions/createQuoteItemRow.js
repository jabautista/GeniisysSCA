/**
 * Creates a new div that will hold the quote item row
 * @param obj - JSON Object that contains the quote item information
 * 
 */

function createQuoteItemRow(obj){
	var content =  prepareQuoteItemTable(obj);										
	var newDiv = new Element("div");
	
	newDiv.setAttribute("id", "row"+obj.quoteId+obj.itemNo);
	newDiv.setAttribute("name", "row");
	newDiv.setAttribute("quoteId", obj.quoteId);
	newDiv.setAttribute("itemNo", obj.itemNo);
	newDiv.setAttribute("currencyCd", obj.currencyCd);
	newDiv.setAttribute("currencyRt", obj.currencyRate);
	newDiv.addClassName("tableRow");
	newDiv.update(content);
	return newDiv;
}