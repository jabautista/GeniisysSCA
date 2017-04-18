function setCoverForm(obj) {
	try {
		$("cPerilCd").value			= obj == null ? "" : obj.perilCd;
		$("cPerilName").value		= obj == null ? "" : unescapeHTML2(nvl(obj.perilName, ""));
		$("cPremRt").value			= obj == null ? "" : formatToNineDecimal(nvl(obj.premRt, "0"));
		$("cTsiAmt").value			= obj == null ? "" : formatCurrency(nvl(obj.tsiAmt, "0"));
		$("cPremAmt").value			= obj == null ? "" : formatCurrency(nvl(obj.premAmt, "0"));
		$("cAnnTsiAmt").value			= obj == null ? "" : formatCurrency(nvl(obj.annTsiAmt, "0")); // added by Irwin
		$("cAnnPremAmt").value			= obj == null ? "" : formatCurrency(nvl(obj.annPremAmt, "0"));// added by Irwin
		$("cNoOfDays").value		= obj == null ? "" : obj.noOfDays;
		$("cBaseAmt").value			= obj == null ? "" : formatCurrency(nvl(obj.baseAmt, "0"));
		$("cAggregateSw").checked	= obj == null ? false : (obj.aggregateSw == "Y" ? true : false);
		$("cAnnPremAmt").value		= obj == null ? "" : formatCurrency(nvl(obj.annPremAmt, "0"));
		$("cAnnTsiAmt").value		= obj == null ? "" : formatCurrency(nvl(obj.annTsiAmt, "0"));
		$("cRecFlag").value			= obj == null ? "" : obj.recFlag; 
		$("cRiCommRt").value		= obj == null ? "" : formatToNineDecimal(nvl(obj.riCommRt, "0"));
		$("cRiCommAmt").value		= obj == null ? "" : formatCurrency(nvl(obj.riCommAmt, "0"));
		$("cPerilType").value = obj == null ? "" : obj.perilType;
		$("btnAddCoverage").value	= obj == null ? "Add" : "Update";		
		$("annTsiCopy").value = obj == null ? "" : formatCurrency(nvl(obj.annTsiAmt, "0")); // belle 09202012
		$("annPremCopy").value = obj == null ? "" : nvl(obj.origAnnPremAmt, "0"); // added by: Nica 10.03.2012
		
		if(obj == null){
			disableButton($("btnDeleteCoverage"));
			disableButton($("btnCopyBenefits"));
			// $("cPerilCd").show(); // andrew - 01.10.2012 - comment out
			// $("cPerilName").hide();	// andrew - 01.10.2012 - comment out
		}else{
			enableButton($("btnDeleteCoverage"));
			enableButton($("btnCopyBenefits"));
			//$("cPerilCd").hide(); // andrew - 01.10.2012 - comment out
			//$("cPerilName").show(); // andrew - 01.10.2012 - comment out
		}
		
	} catch(e) {
		showErrorMessage("setCoverForm", e);
	}
}