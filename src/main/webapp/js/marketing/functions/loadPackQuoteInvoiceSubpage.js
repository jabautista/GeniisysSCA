/**
 * Loads the invoice information sub-page  
 * for Package Quotation Information
 */

function loadPackQuoteInvoiceSubpage(){
	new Ajax.Updater("invoiceInformationMotherDiv", 
		contextPath + "/GIPIQuotationInvoiceController",{
		method : "GET",
		asynchronous : true,
		evalScripts : true,
		parameters: {
			action : "showQuoteInvoiceForPackQuotation",
			packQuoteId : objMKGlobal.packQuoteId,
			issCd : objMKGlobal.issCd
		},
		onCreate: function(){
			showNotice("Processing information, please wait...");	
		},
		onComplete:	function(response){
			hideNotice();
			if(checkErrorOnResponse(response)){
				$("invoiceAccordionLbl").innerHTML = "Show";
			}else{
				showMessageBox(response.responseText, imgMessage.ERROR);
			}
		}
	});
}