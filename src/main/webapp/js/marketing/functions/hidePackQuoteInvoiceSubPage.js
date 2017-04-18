/**
 * Hides the sub-page of Quote Invoice Information 
 * for Package Quotation Information
 * 
 */

function hidePackQuoteInvoiceSubPage(){
	$("invoiceAccordionLbl").innerHTML = "Show";
	$("invoiceInformationMotherDiv").down("div", 0).hide();
}