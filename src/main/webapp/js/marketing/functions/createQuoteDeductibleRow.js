/**
 * Creates a new div that will hold the quote deductible row
 * @param deductibleObj - JSON Object that contains the quote deductible information
 * 
 */

function createQuoteDeductibleRow(deductibleObj){
	var content = prepareQuoteDeductibleTable(deductibleObj);
	var deductRow = new Element("div");
	
	deductRow.setAttribute("id", "deductibleRow" +deductibleObj.quoteId+ deductibleObj.itemNo + "" + deductibleObj.perilCd + "" + deductibleObj.dedDeductibleCd);
	deductRow.setAttribute("name", "deductibleRow");
	deductRow.setAttribute("quoteId", deductibleObj.quoteId);
	deductRow.setAttribute("itemNo", deductibleObj.itemNo);
	deductRow.setAttribute("perilCd", deductibleObj.perilCd);
	deductRow.setAttribute("deductibleCd", deductibleObj.dedDeductibleCd);
	deductRow.addClassName("tableRow");
	deductRow.update(content);
	return deductRow;
}