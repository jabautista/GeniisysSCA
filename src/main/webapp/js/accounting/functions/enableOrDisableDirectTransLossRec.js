/**
 * Enable or disable the primary field in module GIACS010
 * 
 * @author Jerome Orio 10.11.2010
 * @version 1.0
 * @param selected
 *            row
 * @return
 */
function enableOrDisableDirectTransLossRec(obj) {
	if (obj.recordStatus == null) {
		// if ($F("hidTranFlag") != "O" ){
		$("txtCollectionAmtLossRec").readOnly = true;
		$("foreignCurrAmtLossRec").readOnly = true;
		$("currencyCdLossRec").readOnly = true;
		$("convertRateLossRec").readOnly = true;
		$("selPayorClassCdLossRec").hide();
		$("readOnlyPayorClassCdLossRec").show();
		$("readOnlyPayorClassCdLossRec").value = getListTextValue("selPayorClassCdLossRec");
		$("selTransactionTypeLossRec").hide();
		$("readOnlyTransactionTypeLossRec").show();
		$("readOnlyTransactionTypeLossRec").value = getListTextValue("selTransactionTypeLossRec");
		$("chkAcctEntTagLossRec").disable();
		$("txtRemarksLossRec").readOnly = true;
		objAC.hidObjGIACS010.hidUpdateable = "N";
		disableSearch("payorNameLOV");
		disableSearch("recoveryNoLossRecDate");
		disableButton("btnAddLossRec");
	} else {
		$("txtCollectionAmtLossRec").readOnly = false;
		$("foreignCurrAmtLossRec").readOnly = false;
		$("currencyCdLossRec").readOnly = false;
		$("convertRateLossRec").readOnly = false;
		$("selPayorClassCdLossRec").show();
		$("readOnlyPayorClassCdLossRec").hide();
		$("selTransactionTypeLossRec").show();
		$("readOnlyTransactionTypeLossRec").hide();
		$("chkAcctEntTagLossRec").enable();
		$("txtRemarksLossRec").readOnly = false;
		objAC.hidObjGIACS010.hidUpdateable = "Y";
		enableSearch("payorNameLOV");
		enableSearch("recoveryNoLossRecDate");
		enableButton("btnAddLossRec");
	}
}