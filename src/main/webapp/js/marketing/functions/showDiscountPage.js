/**
 * @return
 */
function showDiscountPage(){
	var quoteId = getQuotationSelectedRow();

	if ($$("div#quotationListingTable div[name='row']").size() == 0){
		quoteId = objGIPIQuote.quoteId;
	}

	if (quoteId == 0 && (typeof errorMessage) != undefined){
		showQuotationListingError("Please select a quotation.");
		return false;
	} else {
		new Ajax.Updater("quoteInfoDiv",contextPath	+ "/GIPIQuotationDiscountController?action=showDiscountPage",{	
			method : "GET",
			parameters : {
				quoteId : quoteId,
				ajax : "1"
			},
			evalScripts : true,
			asynchronous : true,
			onCreate : showNotice("Getting discount information, please wait..."),
			onComplete : function() {
				hideNotice();
				$("quoteListingMainDiv").hide(); // andrew - 02.09.2012
				$("quoteInfoDiv").show();
				Effect.Appear("quotationDiscountMainDiv", {
					duration : .001
				});
				setDocumentTitle("Discount/Surcharge Information");
				addStyleToInputs();
				initializeAll();
			}
		});
	}
}