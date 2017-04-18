/**
 * Enable or disable the primary field in module GIACS039
 * 
 * @author Jerome Orio 09.21.2010
 * @version 1.0
 * @param selected
 *            row
 * @return
 */
function enableOrDisableDirectTransInputVat(obj) {
	if (obj.recordStatus == null) {
		$("selTransactionTypeInputVat").disable();
		$("selPayeeClassCdInputVat").disable();
		$("txtReferenceNoInputVat").readOnly = true;
		$("payeeInputVatDate").hide();
		$("selTransactionTypeInputVat").hide();
		$("selPayeeClassCdInputVat").hide();
		$("readOnlyTransactionTypeInputVat").show();
		$("readOnlyPayeeClassCdInputVat").show();
		$("txtDisbAmtInputVat").readOnly = true;
		$("txtBaseAmtInputVat").readOnly = true;
		$("txtGlAcctCategoryInputVat").readOnly = true;
		$("txtGlControlAcctInputVat").readOnly = true;
		$("txtGlSubAcct1InputVat").readOnly = true;
		$("txtGlSubAcct2InputVat").readOnly = true;
		$("txtGlSubAcct3InputVat").readOnly = true;
		$("txtGlSubAcct4InputVat").readOnly = true;
		$("txtGlSubAcct5InputVat").readOnly = true;
		$("txtGlSubAcct6InputVat").readOnly = true;
		$("txtGlSubAcct7InputVat").readOnly = true;
		$("acctCodeInputVatDate").hide();
		$("slCdInputVatDate").hide();
		$("txtRemarksInputVat").readOnly = true;
		$("selItemNoInputVat").hide();
		$("readOnlyItemNoDescInputVat").value = getListTextValue("selItemNoInputVat");
		$("readOnlyItemNoDescInputVat").show();
		$("selVatSlCdInputVat").hide();
		$("readOnlyVatSlCdDescInputVat").value = getListTextValue("selVatSlCdInputVat");
		$("readOnlyVatSlCdDescInputVat").show();
		objAC.hidObjGIACS039.hidUpdateable = "N";
		disableButton("btnAddInputVat");
	} else {
		$("selTransactionTypeInputVat").enable();
		$("selPayeeClassCdInputVat").enable();
		$("txtReferenceNoInputVat").readOnly = false;
		$("payeeInputVatDate").show();
		$("selTransactionTypeInputVat").show();
		$("selPayeeClassCdInputVat").show();
		$("readOnlyTransactionTypeInputVat").hide();
		$("readOnlyPayeeClassCdInputVat").hide();
		$("txtDisbAmtInputVat").readOnly = false;
		$("txtBaseAmtInputVat").readOnly = false;
		$("txtGlAcctCategoryInputVat").readOnly = false;
		$("txtGlControlAcctInputVat").readOnly = false;
		$("txtGlSubAcct1InputVat").readOnly = false;
		$("txtGlSubAcct2InputVat").readOnly = false;
		$("txtGlSubAcct3InputVat").readOnly = false;
		$("txtGlSubAcct4InputVat").readOnly = false;
		$("txtGlSubAcct5InputVat").readOnly = false;
		$("txtGlSubAcct6InputVat").readOnly = false;
		$("txtGlSubAcct7InputVat").readOnly = false;
		$("acctCodeInputVatDate").show();
		$("slCdInputVatDate").show();
		$("txtRemarksInputVat").readOnly = false;
		$("selItemNoInputVat").show();
		$("readOnlyItemNoDescInputVat").value = getListTextValue("selItemNoInputVat");
		$("readOnlyItemNoDescInputVat").hide();
		$("selVatSlCdInputVat").show();
		$("readOnlyVatSlCdDescInputVat").value = getListTextValue("selVatSlCdInputVat");
		$("readOnlyVatSlCdDescInputVat").hide();
		objAC.hidObjGIACS039.hidUpdateable = "Y";
		enableButton("btnAddInputVat");
	}
	if ($F("readOnlyVatSlCdDescInputVat").blank()) {
		$("readOnlyVatSlCdDescInputVat").removeClassName("required");
	} else {
		$("readOnlyVatSlCdDescInputVat").addClassName("required");
	}
}