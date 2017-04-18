function resetBasicDiscountForm1(){
	generateSequenceGIPIS143(); 
	$("premAmt").value = formatCurrency($("paramPremAmt").value);
	$("discountAmt").clear();
	$("discountRt").clear();
	$("surchargeAmt").clear();
	$("surchargeRt").clear();
	$("grossTag").checked = true;						
	$("remark").value = "";

	$$("div[name='rowBasic']").each(function (div) {
		div.removeClassName("selectedRow");
	});

	$('btnAddDiscount').value = "Add";
	disableButton("btnDelDiscount");

	$("sequenceNo").enable();
	$("premAmt").enable();
	$("discountAmt").enable();
	$("discountRt").enable();
	$("surchargeAmt").enable();
	$("surchargeRt").enable();
	$("grossTag").enable();
	$("remark").enable();
	enableButton("btnAddDiscount");
	
	generateSequenceGIPIS143(); 
}