/**
* Creates a new div that will hold the quote invoice tax row
* @param invTaxObj - JSON Object that contains the quote invoice tax information
* 
*/

function createQuoteInvTaxRow(invTaxObj){
	var content = prepareQuoteInvTaxTable(invTaxObj);
	var invTaxRow = new Element("div");
	invTaxRow.setAttribute("id", "invoiceTaxRow"+invTaxObj.quoteInvNo+ invTaxObj.taxCd);
	invTaxRow.setAttribute("name", "invoiceTaxRow");
	invTaxRow.setAttribute("quoteInvNo", invTaxObj.quoteInvNo);
	invTaxRow.setAttribute("taxCd", invTaxObj.taxCd);
	invTaxRow.addClassName("tableRow");
	invTaxRow.update(content);
	return invTaxRow;
}