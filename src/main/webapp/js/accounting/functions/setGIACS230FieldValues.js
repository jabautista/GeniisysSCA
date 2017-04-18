// shan 04.26.2013
function setGIACS230FieldValues(reset) {
	if (reset == "Y") {
		objGIACS230.fieldVals = [];
		objGIACS230.dt_basis = null;
		objGIACS230.sl_exists = 0;
		objGIACS230.glTransURL = null;
		objGIACS230.slSummaryURL = null;
		objGIACS230.multiSort = null;
		objGIACS230.msortOrder = [];
		$("hidGlAcctId").value = "";
		$("hidGlAcctType").value = "";
		$("txtGlAcctCat").value = "";
		$("txtGlCtrlAcct").value = "";
		$("txtGlSubAcct1").value = "";
		$("txtGlSubAcct2").value = "";
		$("txtGlSubAcct3").value = "";
		$("txtGlSubAcct4").value = "";
		$("txtGlSubAcct5").value = "";
		$("txtGlSubAcct6").value = "";
		$("txtGlSubAcct7").value = "";
		$("txtGlAcctName").value = "";
		$("hidFundCd").value = "";
		$("txtCompany").value = "";
		$("hidBranchCd").value = "";
		$("hidBranchName").value = "";
		$("txtBranch").value = "";
		toggleGIACS230Buttons(false);
		toggleGIACS230Fields(true);
		$("txtGlAcctCat").focus();

	} else {
		$("hidGlAcctId").value = objGIACS230.fieldVals[0].glAcctId;
		$("hidGlAcctType").value = objGIACS230.fieldVals[0].glAcctType;
		$("txtGlAcctCat").value = objGIACS230.fieldVals[0].glAcctCat;
		$("txtGlCtrlAcct").value = objGIACS230.fieldVals[0].glCtrlAcct;
		$("txtGlSubAcct1").value = objGIACS230.fieldVals[0].glSubAcct1;
		$("txtGlSubAcct2").value = objGIACS230.fieldVals[0].glSubAcct2;
		$("txtGlSubAcct3").value = objGIACS230.fieldVals[0].glSubAcct3;
		$("txtGlSubAcct4").value = objGIACS230.fieldVals[0].glSubAcct4;
		$("txtGlSubAcct5").value = objGIACS230.fieldVals[0].glSubAcct5;
		$("txtGlSubAcct6").value = objGIACS230.fieldVals[0].glSubAcct6;
		$("txtGlSubAcct7").value = objGIACS230.fieldVals[0].glSubAcct7;
		$("txtGlAcctName").value = objGIACS230.fieldVals[0].glAcctName;
		$("hidFundCd").value = objGIACS230.fieldVals[0].fundCd;
		$("txtCompany").value = objGIACS230.fieldVals[0].company;
		$("hidBranchCd").value = objGIACS230.fieldVals[0].branchCd;
		$("hidBranchName").value = objGIACS230.fieldVals[0].branchName;
		$("txtBranch").value = objGIACS230.fieldVals[0].branchCd + " - "
				+ objGIACS230.fieldVals[0].branchName;
		$("chkTranOpen").value = objGIACS230.fieldVals[0].tranOpen;
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		toggleGIACS230Fields(false);
	}
}