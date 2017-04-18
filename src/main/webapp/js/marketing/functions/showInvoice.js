/**
 * Show Invoice and change accordion label 'Hide'
 * 
 * @return
 */
function showInvoice(){
	$("invoiceAccordionLbl").innerHTML	= "Hide";
	$("invoiceAccordionLbl").value		= "Hide"; // as a precaution
	$("invoiceInformationMotherDiv").show();
	
}