function setGIACS237FieldValues(reset) {
	if (reset == "Y") {
		$("txtFundDesc").value = " ";
		$("txtBranchName").value = " ";
		$("txtFundDesc").readOnly = true;
		$("txtBranchName").readOnly = true;
	} else {
		$("txtFundDesc").value = objGlobalGIACS237.fieldVals[0].fundCd;
		$("txtBranchName").value = objGlobalGIACS237.fieldVals[0].branchCd;
		$("txtFundDesc").readOnly = true;
		$("txtBranchName").readOnly = true;
		disableSearch("imgSearchFund");
		disableSearch("imgSearchBranch");
	}
}