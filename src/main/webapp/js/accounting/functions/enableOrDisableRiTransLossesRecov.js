/**
 * Enable or disable the primary field in GIACS009
 * 
 * @author Jerome Orio 10.27.2010
 * @version 1.0
 * @param selected
 *            row
 * @return
 */
function enableOrDisableRiTransLossesRecov(obj) {
	try {
		if (obj.recordStatus == null) {
			$("txtE150LineCdLossesRecov").readOnly = true;
			$("txtE150LaYyLossesRecov").readOnly = true;
			$("txtE150FlaSeqNoLossesRecov").readOnly = true;
			$("txtCollectionAmtLossesRecov").readOnly = true;
			$("txtParticularsLossesRecov").readOnly = true;
			$("foreignCurrAmtLossesRecov").readOnly = true;
			$("currencyCdLossesRecov").readOnly = true;
			$("convertRateLossesRecov").readOnly = true;

			$("selTransactionTypeLossesRecov").hide();
			$("selTransactionTypeLossesRecov").disable();
			$("readOnlyTransactionTypeLossesRecov").show();
			$("readOnlyTransactionTypeLossesRecov").value = getListTextValue("selTransactionTypeLossesRecov");

			$("selShareTypeLossesRecov").hide();
			$("selShareTypeLossesRecov").disable();
			$("readOnlyShareTypeLossesRecov").show();
			$("readOnlyShareTypeLossesRecov").value = getListTextValue("selShareTypeLossesRecov");

			$(objAC.hidObjGIACS009.hidCurrReinsurer).hide();
			$(objAC.hidObjGIACS009.hidCurrReinsurer).disable();
			$("readOnlyA180RiCdLossesRecov").show();
			$("readOnlyA180RiCdLossesRecov").value = getListTextValue(objAC.hidObjGIACS009.hidCurrReinsurer);

			objAC.hidObjGIACS009.hidUpdateable = "N";
			disableButton("btnAddLossesRecov");
		} else {
			$("txtE150LineCdLossesRecov").readOnly = false;
			$("txtE150LaYyLossesRecov").readOnly = false;
			$("txtE150FlaSeqNoLossesRecov").readOnly = false;
			$("txtCollectionAmtLossesRecov").readOnly = false;
			$("txtParticularsLossesRecov").readOnly = false;
			$("foreignCurrAmtLossesRecov").readOnly = false;
			$("currencyCdLossesRecov").readOnly = false;
			$("convertRateLossesRecov").readOnly = false;

			$("selTransactionTypeLossesRecov").show();
			$("selTransactionTypeLossesRecov").enable();
			$("readOnlyTransactionTypeLossesRecov").hide();
			$("readOnlyTransactionTypeLossesRecov").clear();

			$("selShareTypeLossesRecov").show();
			$("selShareTypeLossesRecov").enable();
			$("readOnlyShareTypeLossesRecov").hide();
			$("readOnlyShareTypeLossesRecov").clear();

			$(objAC.hidObjGIACS009.hidCurrReinsurer).show();
			$(objAC.hidObjGIACS009.hidCurrReinsurer).enable();
			$("readOnlyA180RiCdLossesRecov").hide();
			$("readOnlyA180RiCdLossesRecov").clear();

			objAC.hidObjGIACS009.hidUpdateable = "Y";
			enableButton("btnAddLossesRecov");
		}
	} catch (e) {
		showErrorMessage("enableOrDisableRiTransLossesRecov", e);
		// showMessageBox("Error on
		// enableOrDisableRiTransLossesRecov:"+e.message, imgMessage.ERROR);
	}
}