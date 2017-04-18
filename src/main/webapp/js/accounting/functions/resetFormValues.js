function resetFormValues(){
	$("tranType").selectedIndex = 0;
	$("tranSource").selectedIndex = 0;
	$("billCmNo").value = null;
	$("instNo").value = null;
	$("premCollectionAmt").value = formatCurrency(0);
	$("directPremAmt").value = formatCurrency(0);
	$("taxAmt").value = formatCurrency(0);
	$("assdName").value = null;
	$("polEndtNo").value = null;
	$("particulars").value = null;
	
	/*
	//objAC.currCd = "";
	// $("currCd").value = "";
	//objAC.currRt = "";
	// $("currRt").value = "";
	objAC.currShortName = "";
	// $("currShortName").value = "";
	objAC.currDesc = "";
	// $("currDesc").value = "";
	objAC.origCollAmt = "0.0";
	// $("origCollAmt").value = "0.0";
	objAC.origPremAmt = "0.0";
	// $("origPremAmt").value = "0.0";
	objAC.origTaxAmt = "0.0";
	// $("origTaxAmt").value = "0.0";
	objAC.policyId = null;
	// $("policyId").value = null;
	objAC.lineCd = null;
	// $("lineCd").value = null;*/
	objAC.currentRecord = {};
	//enableButton("btnForeignCurrency");
	disableButton("btnForeignCurrency");
	if ($$("div[name='rowPremColln']").size() == 0){
		disableButton("btnUpdate");
		disableButton("btnSpecUpdate");
	}else {
		enableButton("btnUpdate");
		enableButton("btnSpecUpdate");
	}
}