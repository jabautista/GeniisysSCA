/**
 * Populate form data when user select a record in module GIACS039
 * 
 * @author Jerome Orio 09.21.2010
 * @version 1.0
 * @param obj -
 *            object of giac_input_vat records objArray - object array for
 *            slName listing
 * @return
 */
function supplyDirectTransInputVat(obj, objArray) {
	try {
		var hiddenObjGiacInputVat = new Object();
		hiddenObjGiacInputVat.recordStatus = obj.recordStatus;
		$("selTransactionTypeInputVat").value = (obj.transactionType == null ? ""
				: nvl(obj.transactionType, ""));
		$("selPayeeClassCdInputVat").value = changeSingleAndDoubleQuotes((obj.payeeClassCd == null ? ""
				: nvl(obj.payeeClassCd, "")));
		$("hidPayeeNoInputVat").value = (obj.payeeNo == null ? "" : nvl(
				obj.payeeNo, ""));
		$("txtPayeeNameInputVat").value = changeSingleAndDoubleQuotes((obj.dspPayeeName == null ? ""
				: nvl(obj.dspPayeeName, "")));
		$("txtReferenceNoInputVat").value = changeSingleAndDoubleQuotes((obj.referenceNo == null ? ""
				: nvl(obj.referenceNo, "")));
		$("selItemNoInputVat").value = (obj.itemNo == null ? "" : nvl(
				obj.itemNo, ""));
		updateSlNameLOV(objArray);
		if ($("selItemNoInputVat").options[$("selItemNoInputVat").selectedIndex]
				.getAttribute("gsltSlTypeCd") != "") {
			$("selVatSlCdInputVat").enable();
			$("selVatSlCdInputVat").addClassName("required");
		} else {
			$("selVatSlCdInputVat").selectedIndex = 0;
			$("selVatSlCdInputVat").disable();
			$("selVatSlCdInputVat").removeClassName("required");
		}
		$("selVatSlCdInputVat").value = (obj.vatSlCd == null ? "" : nvl(
				obj.vatSlCd, ""));
		$("txtDisbAmtInputVat").value = formatCurrency((obj.baseAmt == null ? 0
				: nvl(parseFloat(obj.baseAmt.replace(/,/g, "")), 0))
				+ (obj.inputVatAmt == null ? 0 : nvl(parseFloat(obj.inputVatAmt
						.replace(/,/g, "")), 0)));
		$("txtBaseAmtInputVat").value = formatCurrency((obj.baseAmt == null ? ""
				: nvl(obj.baseAmt, "")));
		$("txtInputVatAmtInputVat").value = formatCurrency((obj.inputVatAmt == null ? ""
				: nvl(obj.inputVatAmt, "")));
		$("txtGlAcctCategoryInputVat").value = (obj.glAcctCategory == null ? ""
				: nvl(obj.glAcctCategory, ""));
		$("txtGlControlAcctInputVat").value = (obj.glControlAcct == null ? ""
				: nvl(obj.glControlAcct, ""));
		$("txtGlSubAcct1InputVat").value = (obj.glSubAcct1 == null ? "" : nvl(
				obj.glSubAcct1, ""));
		$("txtGlSubAcct2InputVat").value = (obj.glSubAcct2 == null ? "" : nvl(
				obj.glSubAcct2, ""));
		$("txtGlSubAcct3InputVat").value = (obj.glSubAcct3 == null ? "" : nvl(
				obj.glSubAcct3, ""));
		$("txtGlSubAcct4InputVat").value = (obj.glSubAcct4 == null ? "" : nvl(
				obj.glSubAcct4, ""));
		$("txtGlSubAcct5InputVat").value = (obj.glSubAcct5 == null ? "" : nvl(
				obj.glSubAcct5, ""));
		$("txtGlSubAcct6InputVat").value = (obj.glSubAcct6 == null ? "" : nvl(
				obj.glSubAcct6, ""));
		$("txtGlSubAcct7InputVat").value = (obj.glSubAcct7 == null ? "" : nvl(
				obj.glSubAcct7, ""));
		$("hidGsltSlTypeCdInputVat").value = (obj.gsltSlTypeCd == null ? ""
				: nvl(obj.gsltSlTypeCd, ""));
		$("hidGlAcctIdInputVat").value = (obj.glAcctId == null ? "" : nvl(
				obj.glAcctId, ""));
		$("txtDspAccountName").value = changeSingleAndDoubleQuotes((obj.glAcctName == null ? ""
				: nvl(obj.glAcctName, "")));
		$("hidSlCdInputVat").value = (obj.slCd == null ? "" : nvl(obj.slCd, ""));
		$("txtSlNameInputVat").value = changeSingleAndDoubleQuotes((obj.slName == null ? ""
				: nvl(obj.slName, "")));
		$("txtRemarksInputVat").value = changeSingleAndDoubleQuotes((obj.remarks == null ? ""
				: nvl(obj.remarks, "")));
		hiddenObjGiacInputVat.hidOrPrintTagInputVat = (obj.orPrintTag == null ? ""
				: nvl(obj.orPrintTag, ""));
		hiddenObjGiacInputVat.hidCpiRecNoInputVat = (obj.cpiRecNo == null ? ""
				: nvl(obj.cpiRecNo, ""));
		hiddenObjGiacInputVat.hidCpiBranchCdInputVat = changeSingleAndDoubleQuotes((obj.cpiBranchCd == null ? ""
				: nvl(obj.cpiBranchCd, "")));
		$("hidVatGlAcctId").value = (obj.vatGlAcctId == null ? "" : nvl(
				obj.vatGlAcctId, ""));
		$("readOnlyTransactionTypeInputVat").value = changeSingleAndDoubleQuotes(obj.transactionType
				+ " - "
				+ (obj.transactionTypeDesc == null ? "" : nvl(
						obj.transactionTypeDesc, "")));
		$("readOnlyPayeeClassCdInputVat").value = changeSingleAndDoubleQuotes((obj.payeeClassDesc == null ? ""
				: nvl(obj.payeeClassDesc, "")));
		enableOrDisableDirectTransInputVat(obj);
		return hiddenObjGiacInputVat;
	} catch (e) {
		showErrorMessage("supplyDirectTransInputVat", e);
	}
}