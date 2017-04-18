function enableDisableLossExpTaxForm(enableSw){
	if(enableSw == "enable"){
		$("selTaxType").enable();
		$("hrefTaxCd").show();
		$("hrefSLCode").show();
		$("hrefTaxLossExpCd").show();
	}else{
		$("selTaxType").disable();
		$("hrefTaxCd").hide();
		$("hrefSLCode").hide();
		$("hrefTaxLossExpCd").hide();
		$("txtTaxBaseAmt").readOnly = true;
		disableButton($("btnAddLossExpTax"));
		disableButton($("btnDeleteLossExpTax"));
		disableButton($("btnSaveTax"));
	}
}