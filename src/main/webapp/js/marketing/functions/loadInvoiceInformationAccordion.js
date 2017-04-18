function loadInvoiceInformationAccordion(){
	try{
		var quoteId 	= objGIPIQuote.quoteId;	// $("mainContents").down("input", 0).value;
		var lineCd 		= objGIPIQuote.lineCd;	// $F("lineCd");
		var issCd 		= objGIPIQuote.issCd;	// $F("issCd");
		var currencyCd 	= $F("selCurrency");
		var rate 		= $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRate");	// $F("rate");
		var currencyName = $("selCurrency").options[$("selCurrency").selectedIndex].text; // $("currency").options[$("currency").selectedIndex].text;
		var params 		= "";
		
		new Ajax.Updater("invoiceInformationMotherDiv", contextPath + "/GIPIQuotationInvoiceController?action=showQuoteInvoicePage",{
			asynchronous:	false,
			evalScripts:	true,
			method:			"GET",
			parameters:{
				quoteId:	quoteId
			},
			onComplete: function(response){
				enableQuotationMainButtons();
				showAccordionLabelsOnQuotationMain();
				return true;
			},
			onError: function(){
				return false;
			}
		});
	}catch(e){
//		showErrorMessage("loadInvoiceInformation Accordion too: ", e); //hidden
		return false;
	}
}