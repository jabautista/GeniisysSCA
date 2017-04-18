function populateDepreciationDtlFields(obj){
	try{
		$("lossExpCd").value = obj == null ? "": obj.lossExpCd;
		$("partDesc").value = obj == null ? "": unescapeHTML2(obj.partDesc);
		$("dedRt").value = obj == null ? "": formatCurrency(obj.dedRt);
		$("partAmt").value = obj == null ? "": formatCurrency(obj.partAmt);
		$("dedAmt").value = obj == null ? "": formatCurrency(obj.dedAmt);
		$("lossExpCd").value = obj == null ? "": obj.lossExpCd;
		$("partType").value = obj == null ? "": obj.partType;
		$("itemNo").value = obj == null ? "": obj.itemNo;
		// store the previous amount and rate for validation
		prevDedRt =obj == null ? "": formatCurrency(obj.dedRt);
		prevDedAmt = obj == null ? "":formatCurrency(obj.dedAmt);
		if(variablesObj.masterDepreciationBlkMasterAllowUpdate == "Y"){
			if(obj == null){
				disableButton("btnUpdateDepDet");
				disableInputField("dedRt");
			}else{
				enableInputField("dedRt");
				enableButton("btnUpdateDepDet");
			}
		}else{
			disableInputField("dedRt");
		}
	}catch(e){
		showErrorMessage("populateRepairLpsDtlFields",e);
	}
}