/**
 * Hide Invoice and change accordion label 'Show'
 * @return
 */
function hideInvoice(){
	$("invoiceAccordionLbl").value = "Show";
	$("invoiceAccordionLbl").innerHTML = "Show";
	$("invoiceInformationMotherDiv").hide();
}