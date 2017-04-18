function clearDeductibleForm(){
	$("selDeductibleQuoteItems").selectedIndex = 0;
	$("selDeductibleQuotePerils").selectedIndex = 0;
	$("selDeductibleDesc").selectedIndex = 0;
	$("txtDeductibleAmt").value = formatCurrency("0");
	$("txtDeductibleRate").value = formatToNineDecimal("0");
	$("txtDeductibleText").value = "";
	$("btnAddDeductible").value = "Add";
	enableButton("btnAddDeductible");
	disableButton("btnDeleteDeductible");
	$("txtPerilDisplay").hide();
	$("txtItemDisplay").hide();
	$("txtDedDisplay").hide();
	$("selDeductibleQuotePerils").show();
 	$("selDeductibleQuoteItems").show();
 	$("selDeductibleDesc").show();
}