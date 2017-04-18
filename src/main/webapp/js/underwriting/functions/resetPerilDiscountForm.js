function resetPerilDiscountForm(){
	$("sequenceNoPeril").value = "";
	$("itemNoPeril").selectedIndex = 0;
	$("premAmtPeril").value = formatCurrency("0");
	$("paramOrigPerilPremAmt").value = formatCurrency("0");
	$("origPerilAnnPremAmt").value = formatCurrency("0");
	$("origItemAnnPremAmt").value = formatCurrency("0");
	$("origPolAnnPremAmt").value = formatCurrency("0");
	$("discountAmtPeril").clear();
	//$("discountRtPeril").value = "0.0000"; //$("discountRtPeril").clear(); // replaced with code below : shan 11.27.2014
	$("lblModuleId").getAttribute("moduleId") == "GIPIS143" ? $("discountRtPeril").clear() : $("discountRtPeril").value = "0.0000";
	$("surchargeAmtPeril").clear();
	$("surchargeRtPeril").clear();
	$("grossTagPeril").checked = true;				
	$("remarkPeril").value = "";
	$("btnAddDiscountPeril").value = "Add";
	disableButton("btnDelDiscountPeril");
	$$("div[name='rowPeril']").each(function (div) {
		div.removeClassName("selectedRow");
	});
	$("sequenceNoPeril").enable();
	$("grossTagPeril").enable();
	$("discountAmtPeril").enable();
	$("premAmtPeril").enable();
	$("discountRtPeril").enable();
	$("itemNoPeril").enable();
	$("surchargeAmtPeril").enable();
	$("itemPeril").enable();
	$("surchargeRtPeril").enable();
	$("remarkPeril").enable();
	enableButton("btnAddDiscountPeril");
	if ($("itemPeril").getAttribute("perilCond") == "input"){	//added by steven 10/01/2012
		$("itemNoPeril").clear();
		$("itemPeril").clear();
		enableSearch("searchItemImgPeril");
		disableSearch("searchItemImgPerilDisc");
	}else{
		$("itemPeril").disable();
		$("itemPeril").selectedIndex = 0;
		for(var i = 1; i < $("itemPeril").options.length; i++){
			$("itemPeril").options[i].hide();
			$("itemPeril").options[i].disabled = true;
		}
	}
	generateSequenceGIPIS143();
}