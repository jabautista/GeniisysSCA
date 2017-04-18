function resetItemDiscountForm(){
	$("sequenceNoItem").value = "";
	$("itemNo").clear(); //change by steven from: $("itemNo").selectedIndex = 0;
	$("premAmtItem").clear();
	$("itemTitle").value = "";
//	$("premAmtItem").value = formatCurrency("0");
	$("origPremAmtItem").value = formatCurrency("0");
	$("discountAmtItem").clear();
	$("discountRtItem").clear();
	$("surchargeAmtItem").clear();
	$("surchargeRtItem").clear();
	$("grossTagItem").checked = true;						
	$("remarkItem").value = "";
	$("btnAddDiscountItem").value = "Add";
	disableButton("btnDelDiscountItem");
	$$("div[name='rowItem']").each(function (div) {
		div.removeClassName("selectedRow");
	});
	$("sequenceNoItem").enable();
	$("grossTagItem").enable();
	$("discountAmtItem").enable();
	$("premAmtItem").enable();
	$("discountRtItem").enable();
	$("itemNo").enable();
	$("surchargeAmtItem").enable();
	$("itemTitle").enable();
	$("surchargeRtItem").enable();
	$("remarkItem").enable();
	enableSearch("searchItemImg");
	enableButton("btnAddDiscountItem");	
	generateSequenceGIPIS143(); 
}