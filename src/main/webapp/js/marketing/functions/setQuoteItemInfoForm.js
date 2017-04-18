/**
 * Populate quote item form with values.
 * @param obj - JSON Object that contains the quote item information. Set obj
 * 				to null to reset quote item form. 
 */

function setQuoteItemInfoForm(obj){
	$("txtItemNo").value 		= obj == null ? getNextQuoteItemNo(objPackQuoteItemList) : obj.itemNo;
	$("txtItemTitle").value 	= obj == null ? "" : unescapeHTML2(obj.itemTitle);
	$("txtItemDesc").value 		= obj == null ? "" : unescapeHTML2(obj.itemDesc);
	$("txtItemDesc2").value 	= obj == null ? "" : unescapeHTML2(obj.itemDesc2);
	$("selCurrency").value  	= obj == null ? nvl(objDefaultCurrency, "") : obj.currencyCd;
	$("txtCurrencyRate").value 	= obj == null ? formatToNineDecimal($("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRate")) : formatToNineDecimal(obj.currencyRate);
	$("selCoverage").value 		= obj == null ? "" : obj.coverageCd;

	$("btnAddItem").value = obj == null ? "Add" : "Update";
	(obj == null ? disableButton($("btnDeleteItem")) : enableButton($("btnDeleteItem")));
	(obj == null ? $("txtItemNo").removeAttribute("readonly") : $("txtItemNo").writeAttribute("readonly", "readonly"));
}