function populateLossExpTaxForm(tax){
	try{
		$("selTaxType").value 	= tax == null ? "" : unescapeHTML2(tax.taxType); //Changed by Kenneth 05.26.2015 SR 3625
		$("txtTaxCd").value   	= tax == null ? ""  : unescapeHTML2(tax.taxName);
		$("txtTaxCd").setAttribute("taxCd", tax == null ? "" : tax.taxCd == null ? "" : lpad((tax.taxCd).toString(), 5, "0"));
		$("txtSLCode").value   	= tax == null ? ""  : tax.slCd == null ? "" :lpad((tax.slCd).toString(), 12, "0");
		$("txtTaxLossExpCd").value = tax == null ? "" : unescapeHTML2(tax.lossExpCd);
		$("txtTaxLossExpCd").setAttribute("lossExpCd", tax == null ? ""  : unescapeHTML2(tax.lossExpCd));
		$("txtTaxBaseAmt").value = tax == null ? "" : formatCurrency(tax.baseAmt);
		$("txtTaxPct").value 	= tax == null ? "" : formatToNineDecimal(tax.taxPct);
		$("txtTaxAmt").value 	= tax == null ? "" : formatCurrency(tax.taxAmt);
		$("hidTaxId").value 	= tax == null ? $("hidNextTaxId").value : tax.taxId;
		$("hidSlTypeCd").value 	= tax == null ? "" : nvl(tax.slTypeCd, "");
		$("hidWTax").value 		= tax == null ? "" : nvl(tax.withTax, "");
		$("hidNetTag").value 	= tax == null ? "" : nvl(tax.netTag, "");
		$("hidAdvTag").value 	= tax == null ? "" : nvl(tax.advTag, "");
		(tax == null ? enableButton($("btnAddLossExpTax")) : disableButton($("btnAddLossExpTax")));
		(tax == null ? disableButton($("btnDeleteLossExpTax")) : enableButton($("btnDeleteLossExpTax")));
		
		if(tax == null){
			$("selTaxType").enable();
			$("hrefTaxCd").show();
			$("hrefSLCode").show();
			$("hrefTaxLossExpCd").show();
			//$("txtTaxBaseAmt").readOnly = false;
			$("slCodeDiv").removeClassName("required");
			$("hidWTax").value = "";
		}else{
			$("selTaxType").disable();
			$("hrefTaxCd").hide();
			$("hrefSLCode").hide();
			$("txtTaxBaseAmt").readOnly = true;
			$("hrefTaxLossExpCd").hide();
		}
		
		checkLossExpTaxForUpdate(tax);
	}catch(e){
		showErrorMessage("populateLossExpTaxForm", e);
	}
}