// reset/clear all fields of quotation item peril form
function resetQuoteItemPerilForm() {
	$("selPerilName").value = "";
	$("txtPerilRate").value	= formatToNineDecimal("0");
	$("txtTsiAmount").value	= formatCurrency("0");
	$("txtPremiumAmount").value	= formatCurrency("0");
	$("txtRemarks").value = "";
	$("btnAddPeril").value	= "Add";
	disableButton("btnDeletePeril");
	$("messagePeril").hide();
	$$("div[name='perilRow']").each(function(r) {
		r.removeClassName("selectedRow");
	});
}