/**
* Creates a new div that will hold the quote mortgagee row
* @param mortgageeObj - JSON Object that contains the quote mortgagee information
* 
*/

function createQuoteMortgageeRow(mortgageeObj){
	var content = prepareQuoteMortgageeTable(mortgageeObj);
	var mortgRow = new Element("div");
	mortgRow.setAttribute("id", "mortgageeRow" +mortgageeObj.quoteId+ mortgageeObj.itemNo + mortgageeObj.mortgCd.replace(/ /g, "_"));
	mortgRow.setAttribute("name", "mortgageeRow");
	mortgRow.setAttribute("quoteId", mortgageeObj.quoteId);
	mortgRow.setAttribute("itemNo", mortgageeObj.itemNo);
	mortgRow.setAttribute("mortgCd", mortgageeObj.mortgCd);
	mortgRow.addClassName("tableRow");
	mortgRow.update(content);
	return mortgRow;
}