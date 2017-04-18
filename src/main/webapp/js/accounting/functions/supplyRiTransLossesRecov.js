/**
 * Populate form data when user select a record in module GIACS009
 * 
 * @author Jerome Orio 10.27.2010
 * @version 1.0
 * @param obj -
 *            object of giac_loss_ri_collns records
 * @return
 */
function supplyRiTransLossesRecov(obj) {
	try {
		objAC.objLossesRecovAC009.recordStatus = obj.recordStatus;
		$("selTransactionTypeLossesRecov").value = (obj.transactionType == null ? ""
				: nvl(obj.transactionType, ""));
		$("selShareTypeLossesRecov").value = (obj.shareType == null ? "" : nvl(
				obj.shareType, ""));
		$("txtE150LineCdLossesRecov").value = changeSingleAndDoubleQuotes(obj.e150LineCd == null ? ""
				: nvl(obj.e150LineCd, ""));
		$("txtE150LaYyLossesRecov").value = (obj.e150LaYy == null ? "" : nvl(
				formatNumberDigits(obj.e150LaYy, 2), ""));
		$("txtE150FlaSeqNoLossesRecov").value = (obj.e150FlaSeqNo == null ? ""
				: nvl(formatNumberDigits(obj.e150FlaSeqNo, 5), ""));
		$("txtPayeeTypeLossesRecov").value = (obj.payeeType == null ? "" : nvl(
				obj.payeeType, ""));
		$("txtCollectionAmtLossesRecov").value = formatCurrency(obj.collectionAmt == null ? ""
				: nvl(obj.collectionAmt, ""));
		$("txtParticularsLossesRecov").value = changeSingleAndDoubleQuotes(obj.particulars == null ? ""
				: nvl(obj.particulars, ""));
		$("txtDspPolicyLossesRecov").value = changeSingleAndDoubleQuotes(obj.dspPolicy == null ? ""
				: nvl(obj.dspPolicy, ""));
		$("txtDspClaimNoLossesRecov").value = changeSingleAndDoubleQuotes(obj.dspClaim == null ? ""
				: nvl(obj.dspClaim, ""));
		$("txtDspAssuredLossesRecov").value = changeSingleAndDoubleQuotes(obj.dspAssdName == null ? ""
				: nvl(obj.dspAssdName, ""));
		$("currencyCdLossesRecov").value = (obj.currencyCd == null ? "" : nvl(
				obj.currencyCd, ""));
		$("currencyDescLossesRecov").value = changeSingleAndDoubleQuotes(obj.currencyDesc == null ? ""
				: nvl(obj.currencyDesc, ""));
		$("convertRateLossesRecov").value = formatToNineDecimal(obj.convertRate == null ? ""
				: nvl(obj.convertRate, ""));
		$("foreignCurrAmtLossesRecov").value = formatCurrency(obj.foreignCurrAmt == null ? ""
				: nvl(obj.foreignCurrAmt, ""));

		updateRiTransLossRecovLOV();
		$(objAC.hidObjGIACS009.hidCurrReinsurer).value = (obj.a180RiCd == null ? ""
				: nvl(obj.a180RiCd, ""));
		objAC.hidObjGIACS009.hidOrPrintTag = (obj.orPrintTag == null ? ""
				: nvl(obj.orPrintTag, ""));
		objAC.hidObjGIACS009.hidClaimId = (obj.claimId == null ? "" : nvl(
				obj.claimId, ""));
		objAC.hidObjGIACS009.hidCpiRecNo = (obj.cpiRecNo == null ? "" : nvl(
				obj.cpiRecNo, ""));
		objAC.hidObjGIACS009.hidCpiBranchCd = changeSingleAndDoubleQuotes((obj.cpiBranchCd == null ? ""
				: nvl(obj.cpiBranchCd, "")));
		objAC.hidObjGIACS009.hidWsCollectionAmt = (obj.wsCollectionAmt == null
				|| obj.wsCollectionAmt == undefined ? "" : nvl(
				obj.wsCollectionAmt, ""));
		objAC.hidObjGIACS009.hidWsForeignCurrAmt = (obj.wsForeignCurrAmt == null
				|| obj.wsForeignCurrAmt == undefined ? "" : nvl(
				obj.wsForeignCurrAmt, ""));

		enableOrDisableRiTransLossesRecov(obj);
	} catch (e) {
		showErrorMessage("supplyRiTransLossesRecov", e);
		// showMessageBox("Error on supplyRiTransLossesRecov:"+e.message,
		// imgMessage.ERROR);
	}
}