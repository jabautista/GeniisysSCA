function populateLossExpDtlForm(lossExpDtl){
	try{
		$("txtLoss").value = lossExpDtl == null ? "" : unescapeHTML2(lossExpDtl.dspExpDesc);
		$("txtLoss").setAttribute("lossExpCd", lossExpDtl == null ? "" : lossExpDtl.lossExpCd);
		$("txtUnits").value = lossExpDtl == null ? 1 : lossExpDtl.nbtNoOfUnits;
		$("txtBaseAmt").value = lossExpDtl == null ? "" : formatCurrency(lossExpDtl.dedBaseAmt);
		$("txtBaseAmt").setAttribute("lastValidValue", (lossExpDtl == null ? "" : lossExpDtl.dedBaseAmt));
		$("txtLossAmt").value = lossExpDtl == null ? "" : formatCurrency(lossExpDtl.dtlAmt);
		$("txtAmtLessDed").value = lossExpDtl == null ? "" : formatCurrency(lossExpDtl.nbtNetAmt);
		$("btnAddLossExpDtl").value = lossExpDtl == null ? "Add" : "Update";
		(lossExpDtl == null ? disableButton($("btnDeleteLossExpDtl")): enableButton($("btnDeleteLossExpDtl")));
		$("chkOriginalSw").checked = lossExpDtl == null ? false : (lossExpDtl.originalSw == "Y" ? true : false);
		$("chkWithTax").checked = lossExpDtl == null ? false : (lossExpDtl.withTax == "Y" ? true : false);
		$("hidNbtCompSw").value = lossExpDtl == null ? "" : lossExpDtl.nbtCompSw;
		$("hidLossExpClass").value = lossExpDtl == null ? "" : lossExpDtl.lossExpClass;
		$("hidSublineCd").value = lossExpDtl == null ? "" : lossExpDtl.sublineCd;
		checkGiclLossExpDtlForUpdate(lossExpDtl);
	}catch(e){
		showErrorMessage("populateLossExpDtlForm", e);
	}
}