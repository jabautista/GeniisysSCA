function populateLossExpDeductibleForm(ded){
	try{
		$("txtLossExpCd").value    	 = ded == null ? "" : unescapeHTML2(ded.dspExpDesc);
		$("txtLossExpCd").setAttribute("lossExpCd", ded == null ? "" : ded.lossExpCd);
		$("txtDedLossExpCd").value 	 = ded == null ? "" : unescapeHTML2(ded.dspDedLeDesc);
		$("txtDedLossExpCd").setAttribute("dedLossExpCd", ded == null ? "" : ded.dedLossExpCd);
		$("txtDeductibleType").value = ded == null ? "" : unescapeHTML2(ded.nbtDedType);
		$("txtDeductibleType").setAttribute("dedType", ded == null ? "" : unescapeHTML2(ded.nbtDeductibleType));
		$("txtDeductibleText").value = ded == null ? "" : unescapeHTML2(ded.deductibleText);
		$("txtDedUnits").value 		 = ded == null ? "" : nvl(ded.nbtNoOfUnits, 1);
		$("txtDedRate").value 		 = ded == null ? "" : formatToNineDecimal(nvl(ded.dedRate, 0));
		$("txtDedBaseAmt").value 	 = ded == null ? "" : formatCurrency(ded.dedBaseAmt);
		$("txtDeductibleAmt").value  = ded == null ? "" : formatCurrency(ded.dtlAmt);
		$("hidDedSublineCd").value 	 = ded == null ? "" : unescapeHTML2(ded.sublineCd);
		$("hidDedOriginalSw").value  = ded == null ? "" : unescapeHTML2(ded.originalSw);
		$("hidDedType").value 		 = ded == null ? "" : unescapeHTML2(ded.nbtDeductibleType);
		$("hidDedCompSw").value 	 = ded == null ? "" : unescapeHTML2(ded.nbtCompSw);
		$("hidDedAggregateSw").value = ded == null ? "" : unescapeHTML2(ded.aggregateSw);
		$("hidDedCeilingSw").value 	 = ded == null ? "" : unescapeHTML2(ded.ceilingSw);
		$("hidDedMinAmt").value 	 = ded == null ? "" : nvl(ded.nbtMinAmt, "");
		$("hidDedMaxAmt").value      = ded == null ? "" : nvl(ded.nbtMaxAmt, "");
		$("hidDedRangeSw").value 	 = ded == null ? "" : unescapeHTML2(ded.nbtRangeSw);
		
		$("btnAddLossExpDeductible").value = ded == null ? "Add" : "Update";
		(ded == null ? disableButton($("btnDeleteLossExpDeductible")) : enableButton($("btnDeleteLossExpDeductible")));
		
		if(ded == null){
			$("hrefLossExpCd").show();
			disableButton("btnDeductiblesDetails");
			disableButton("btnComputeDepreciation");
		}else{
			$("hrefLossExpCd").hide();
			enableButton("btnDeductiblesDetails");
			if(objCLMGlobal.lineCd != "MC" && objCLMGlobal.menuLineCd != "MC"){
				disableButton("btnComputeDepreciation");
			}else{
				enableButton("btnComputeDepreciation");
			}
		}
		checkLossExpDeductiblesForUpdate();
	}catch(e){
		showErrorMessage("populateLossExpDeductibleForm", e);
	}
}