/** 
 * Load single deductible information
 * @author rencela
 * @return
 */
function loadDeductibleInformationAccordion() {
	var quoteId = objGIPIQuote.quoteId;
	var itemNo = 0;
	$$("div[name='itemRow']").each(function(itemRow) {
		itemNo = itemRow.down("input", 0).value;
	});
	
	$("deductibleInformationMotherDiv").innerHTML = "";
	
	var sublineCd = $F("sublineCd");
	var lineCd = objGIPIQuote.lineCd;
	var url = "GIPIQuotationDeductiblesController?action=showDeductiblesPage";
	var params = "&quoteId=" + quoteId + "&itemNo=" + itemNo + "&sublineCd="
			+ sublineCd + "&lineCd=" + lineCd;
	new Ajax.Updater("deductibleInformationMotherDiv", url + params, {
		asynchronous : true,
		evalScripts : true,
		method : "GET",
		insertion : "bottom",
		onComplete : function(response) {
			enableQuotationMainButtons();
			showAccordionLabelsOnQuotationMain();		
		}
	});
}