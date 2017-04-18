/**
 * Clear invoiceTax Form
 * @return
 */
function clearInvoiceTaxForm(){
	$("selInvoiceTax").selectedIndex = 0;
	$("txtTaxValue").value = formatCurrency("0");
	
	if($("btnAddInvoice")!=null && $("btnAddInvoice")!=undefined){
		$("btnAddInvoice").value = "Add";
	}else{
		
	}
	
	disableButton("btnDeleteInvoice");
	$("noticePopup").hide();
}