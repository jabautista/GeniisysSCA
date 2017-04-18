/**n
 */
function makeGIPIQuoteMortgageeObject(){
	var mortgageeObj = new Object();
	mortgageeObj.quoteId = objGIPIQuote.quoteId;
	mortgageeObj.issCd = objGIPIQuote.issCd;
	mortgageeObj.itemNo = $F("txtItemNo");
	mortgageeObj.mortgCd = $("selMortgagee").options[$("selMortgagee").selectedIndex].getAttribute("mortgCd");
	mortgageeObj.mortgName = $("selMortgagee").options[$("selMortgagee").selectedIndex].getAttribute("mortgName");
	mortgageeObj.amount = $F("txtMortgageeAmount").replace(/,/g, "");
	return mortgageeObj;
}