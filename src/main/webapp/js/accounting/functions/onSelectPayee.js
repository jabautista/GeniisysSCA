function onSelectPayee(row) {
	$("selPayeeClass2").value = row == null ? "" : row.payeeTypeDescription;
	$("payeeCode").value = row == null ? "" : row.payeeCode;
	$("payeeClassCd").value = row == null ? "" : row.payeeClassCode;
	$("claimLossId").value = row == null ? "" : row.claimLossId;
	$("payeeType").value = row == null ? "" : row.payeeType;
	$("batchCsrId").value = row==null ? "" : row.batchCsrId;//added by reymon 04262013
	//$("hidPerilCd").value = row == null ? "" : row.perilCode;
}