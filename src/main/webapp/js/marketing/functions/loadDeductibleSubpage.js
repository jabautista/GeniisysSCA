function loadDeductibleSubpage(){
	if(checkPendingRecordChanges()){ // Patrick - added condition for validation - 02.14.2012
		new Ajax.Updater("deductibleInformationMotherDiv", 
				contextPath + "/GIPIQuotationDeductiblesController?action=getQuoteDeductibles&quoteId=" + objGIPIQuote.quoteId,{
			asynchronous : true,
			evalScripts : true,
			method : "GET",
			insertion : "bottom",
			onCreate: function(){
			},
			onComplete:	function(){
				enableQuotationMainButtons();
				showAccordionLabelsOnQuotationMain();
				enableButton("btnEditQuotation");
				enableButton("btnSaveQuotation");
				enableButton("btnPrintQuotation");
				hideNotice("SUCCESS");
				Effect.Fade("notice", {			
				  duration : .001
				});
				resetTableStyle("mortgageeInformationDiv", "mortgageeListingDiv", "mortgageeRow");
				hideNotice("");
			}
		});
		function ko(){
			enableButton("btnEditQuotation");
			enableButton("btnSaveQuotation");
			enableButton("btnPrintQuotation");
			hideNotice("SUCCESS");
			Effect.Fade("notice", {			
				duration : .001
			});
		}
		setTimeout(ko, 150);
	}
}